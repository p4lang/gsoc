---
title: "Integrating P4-Based In-Network Machine Learning Framework into P4Pi"
date: 2026-08-24
author: Yuzhong (WeiWei) Luo
permapage: https://github.com/p4lang/gsoc/blob/main/permapage/2026-p4pi.md
draft: false
---

## Abstract

P4Pi brings P4 programming to a Raspberry Pi, making programmable data planes
accessible for teaching and research on hardware costing under £100. Planter
converts trained machine-learning models into P4 programs and match–action table
entries, enabling inference to run directly in the packet-processing path.

The two could not be used together. Planter's low-cost target support ended at
BMv2, which suits functional validation but not sustained traffic, and it had no
adapter for `p4c-dpdk` — the compiler backend for P4Pi's higher-performance DPDK
pipeline.

This project adds that adapter. Along the way it fixes eight previously
undiscovered bugs in Planter's PSA architecture generator, documents six
undocumented limitations in DPDK 20.11's SWX runtime, and rebuilds the P4Pi
system image after its upstream package repositories were found to have been
removed.

## Goals

- A `p4c-dpdk` target adapter for Planter's `src/targets/` abstraction
- One to two additional ML model families validated on the DPDK target
- End-to-end example applications demonstrating in-network ML on P4Pi
- Automated setup and configuration scripts
- A pre-configured P4Pi system image with Planter integrated
- Teaching-oriented documentation

## Results

### The p4c-dpdk target adapter

The adapter lives at `src/targets/dpdk/software/` and implements Planter's target
interface through five stages in `run_model.py`:

| Function | Responsibility |
|---|---|
| `compile_p4_dpdk()` | Runs `p4c --target dpdk --arch psa` and locates the generated `.spec` |
| `patch_spec_file()` | Applies DPDK 20.11 workarounds to the compiled `.spec` |
| `generate_entry_files()` | Converts Planter's ternary tables to exact-match entry files; model-aware, since DT and RF differ structurally |
| `generate_cli_script()` | Writes the `dpdk-pipeline` CLI script with the correct table load order |
| `run_dpdk_pipeline()` | Launches the pipeline in `--no-huge` mode and captures output |

`test_model.py` completes the loop: it builds every test sample into a single
input pcap, runs the pipeline, decodes the classification result from the output
pcap — including a byte-order correction on the label field — and reports
accuracy against the scikit-learn baseline.

### Accuracy

Iris, 70/30 split, Raspberry Pi 4, DPDK 20.11.5:

| Model | scikit-learn | BMv2 | DPDK |
|---|---|---|---|
| Decision Tree (depth 4) | 95.56% | 95.56% | **95.56%** |
| Random Forest (5 trees, depth 4) | 93.33% | 93.33% | **91.11%** |

Decision Tree matches the BMv2 baseline exactly. The Random Forest gap
corresponds to a single test sample being assigned the default action; see
[Known issues](#known-issues).

My mentor separately measured throughput and latency on a Raspberry Pi 5 running
DPDK 23.03, finding a 15× higher lossless packet rate and roughly 9× lower median
latency against BMv2. Those measurements are his rather than mine, but they
indicate what the DPDK path offers over BMv2 once the toolchain is in place.

### Eight bugs in Planter's PSA generator

Planter has two P4 dialects: v1model for BMv2, and PSA. The PSA generator existed
in `src/architectures/psa/` but had never been exercised for ML model generation,
and its output did not compile. Eight distinct fixes were required:

1. Missing `struct metadata_t {}` wrapper — metadata fields were emitted at file
   top level with no enclosing struct
2. Missing `out empty_t` parameters in the ingress deparser
3. Missing `out empty_t` parameters in the egress deparser
4. `empty_t` not defined in this build's `psa.p4` — now emitted explicitly
5. Missing trailing `in empty_t` parameters in the ingress parser
6. Missing trailing `in empty_t` parameters in the egress parser
7. Wrong metadata type in the egress control
   (`psa_egress_parser_input_metadata_t` → `psa_egress_input_metadata_t`)
8. The BMv2 target adapter always invoked the v1model compiler regardless of the
   configured architecture

Most of these come down to PSA's block signatures being stricter than v1model's:
parsers and deparsers must declare parameters for features you may not be using —
cloning, resubmission, recirculation — even when unused.

After these fixes, both `p4c-bm2-psa` and `p4c --target dpdk --arch psa` compile
the generated PSA cleanly. They affect any use of the PSA generator, not only the
DPDK path.

### Six undocumented DPDK 20.11 limitations

P4Pi's SIGCOMM 2022 image ships DPDK 20.11.5. Source-level investigation of
`lib/librte_pipeline/` and `examples/pipeline/cli.c` turned up six limitations
with no upstream documentation:

| Limitation | Workaround |
|---|---|
| No wildcard/ternary table backend — `rte_swx_table_wildcard_match` arrives in DPDK 21.08 | Expand ternary ranges into exact-match entries using Planter's own matching formula `(x & V) == (V & M)` |
| Mask parsing unimplemented in the text entry format — the source contains `/* TBD Set entry->key_mask */` and the mask is never written | Exact-match expansion makes masks unnecessary |
| `lookahead` absent from the SWX instruction set | Remove the lookahead block; the etherType check already gates the path |
| `drop` absent from the SWX instruction set | Replace with `tx` to a sink port |
| Table size must satisfy `n/4 = 2^k` for hash bucket addressing | Compute the size from the actual entry count and round up |
| `n_pkts_max` uninitialised in the `dpdk-pipeline` sample app | Patch `cli.c` to set `n_pkts_max = 0` |

Several of these no longer apply on newer DPDK releases.

One practical finding worth separating out: DPDK's `--no-huge` flag removes the
hugepage reservation step entirely. That matters on P4Pi, where hugepage settings
otherwise need reapplying after every reboot.

### P4Pi system image

The original P4Pi build fetches `p4c` and BMv2 as prebuilt packages from
OpenSUSE OBS repositories. Those repositories no longer exist:

```
$ curl https://api.opensuse.org/public/build/home:p4pi
<status code="unknown_project">Project not found: home:p4pi</status>
```

The same is true for `home:p4edge`. The P4Pi image build is therefore currently
broken for everyone, not only for this project.

Following mentor guidance, the build was reworked to compile from pinned upstream
sources instead — p4c v1.2.5.16 and BMv2 1.15.5, with the BMv2 and DPDK backends
enabled — and to omit PI, T4P4S, the custom kernel, and `p4pi-web`. Planter and a
patched `dpdk-pipeline` are installed at build time, so the image is usable
immediately after flashing with no setup step.

Getting there took eight separate build blockers, documented in
[`image-build/README.md`](https://github.com/pig8pig/Planter/blob/gsoc-p4c-dpdk/image-build/README.md):
QEMU binfmt registration for cross-building ARM on x86; camera packages that fail
under emulation; `py3compile` segfaulting on ARM bytecode generation;
`apt-listchanges` failing in the chroot; and several undocumented BMv2 configure
dependencies.

The most instructive of these: BMv2 1.15.5's `--without-pi` flag is a no-op. The
autoconf macro is declared as `AC_ARG_WITH([pi], ..., [want_pi=yes], [])`, so the
action-if-given fires whenever the flag is present at all — passing
`--without-pi` therefore *enables* PI. Omitting the flag entirely is what
disables it.

### Example applications and setup

Two documented examples ship with the adapter: flow classification using a
Decision Tree, and anomaly detection using a Random Forest. Each includes a
README written for classroom use.

`setup.sh` handles dependency installation, the `dpdk-pipeline` build including
the `n_pkts_max` patch, and the P4Pi-specific compatibility fixes needed to run
Planter on the SIGCOMM 2022 image.

## Challenges

**An untested code path.** The PSA generator existed but had never been run for
ML model generation. Each of the eight bugs had to be found by compiling, reading
an error, tracing it back into the generator, fixing it, and going again.

**Undocumented runtime behaviour.** None of the DPDK 20.11 limitations appear in
any documentation. Each surfaced as an opaque error — `Table configuration
error`, `Pipeline instructions err`, `Commit failed` — and the only way to find
the cause was reading DPDK's source to work out what produced that particular
message.

**Debugging through several layers.** An early symptom — every prediction
returning class 0 — turned out to be four compounding problems. The pipeline
runner treated timeouts as success and silently reused a stale output pcap.
Generated entry files had a format mismatch that caused table updates to be
rejected. Table sizes were under-allocated, so commits failed. And once those
were fixed, class 2 came back as 33554432 (`0x02000000`) — a byte-order mismatch
in the result decoding. Each fix revealed the next.

**Infrastructure disappearing mid-project.** The OBS repositories being removed
turned image packaging from a configuration task into a full source build under
QEMU emulation, at roughly nine hours per attempt.

## Known issues

Three items remain open at the end of the coding period:

- **Random Forest range coverage.** RF reaches 91.11% against a 93.33% BMv2
  baseline. Exact-match expansion should be lossless — it trades memory for
  coverage — so this indicates the expansion is not enumerating every covered
  value for RF's multi-code ternary format.
- **XGBoost.** Compiles and loads its feature tables, but the pipeline crashes at
  runtime on DPDK 20.11.
- **Image boot verification.** The image builds cleanly and passes an in-image
  smoke test, but has not yet been flashed and booted on physical hardware.

## Future work

- Rebuilding the image against DPDK 23.03, on which several of the 20.11
  limitations no longer apply
- Native ternary table support via a DPDK upgrade, removing the need for
  exact-match expansion
- Live-interface testing. TAP devices are created successfully by the DPDK
  runtime, but the `link` and `ethdev` port types in the DPDK 20.11
  `dpdk-pipeline` sample app do not accept them without additional ethdev
  initialisation; testing currently uses pcap source/sink ports
- Upstreaming the PSA generator fixes and the DPDK target to Planter, and the
  image build fixes to P4Pi

## Links

- [Project repository](https://github.com/pig8pig/Planter/tree/gsoc-p4c-dpdk)
- [`p4c-dpdk` target documentation](https://github.com/pig8pig/Planter/blob/gsoc-p4c-dpdk/DPDK_TARGET.md)
- [Image build overlay](https://github.com/pig8pig/Planter/tree/gsoc-p4c-dpdk/image-build)
- [Python 3.12 compatibility fix](https://github.com/In-Network-Machine-Learning/Planter/pull/10)

## Acknowledgements

Thanks to Dr Peng Qian for mentoring throughout, and to Prof. Noa Zilberman and
the Computing Infrastructure Group at Oxford. Thanks also to Davide Scano and the
P4 Language Consortium for organising GSoC 2026.
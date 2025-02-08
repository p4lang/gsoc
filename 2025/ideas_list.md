# P4 GSoC 2025 Ideas List

## Application process

Please check our [Contributor Guidance](contributor_guidance.md) for detailed instructions.

## Potential mentors

1. Anton Korobeynikov ([@asl](https://github.com/asl), anton@korobeynikov.info)
1. Bili Dong ([@qobilidop](https://github.com/qobilidop), bilid@google.com)
1. Davide Scano ([@Dscano](https://github.com/Dscano), d.scano89@gmail.com)
1. Fabian Ruffy ([@fruffy](https://github.com/fruffy), fruffy@nyu.edu)

## FAQ

**What do our project difficulties mean?**

- Easy: Basic coding skills shall suffice.
- Medium: CS undergraduate level knowledge/skills are required.
- Hard: Deeper and more specialized knowledge/skills are required.

**Project sizes are specifided in hours. How many weeks do they correspond to?**

- 90 hour: 8 weeks
- 175 hour: 12 weeks
- 350 hour: 12 weeks

## Project ideas

### Index

- Category: core P4 tooling
  - [Project 1: Finalize Katran P4 and improve the eBPF backend!](#project-1)
  - [Project 2:](#project-2)
  - [Project 10: BMv2 with all possible output packets](#project-10)
- Category: exploratory P4 tooling
  - [Project 3: P4MLIR: MLIR-based high-level IR for P4 compilers](#project-3)
  - [Project 4: P4MLIR BMv2 Dialect Prototype](#project-4)
- Category: P4 application
  - [Project 5:](#project-5)
  - [Project 6:](#project-6)
- Category: P4 research
  - [Project 7:](#project-7)
  - [Project 8:](#project-8)

---

### <a id='project-1'></a> Project 1: Finalize Katran P4 and improve the eBPF backend!

- [Back to index](#index)

**Basic info**

- Potential mentors
  - Primary: Davide Scano
  - Support: To be defined
- Skills
  - Required: [eBPF](https://ebpf.io/)
  - Preferred: [P4C](https://github.com/p4lang/p4c), P4
- Project difficulty: Medium
- Project size: 175 hour / 350 hour
- Discussion thread: TBD

**Alternative qualification task**

If you want to apply to this project, please complete the following qualification task, instead of the general one:

- The knowledge of XDP eBPF is required for this project. We expect you to demonstrate your XDP eBPF skills in one of the following ways:
  - A PR to an existing XDP eBPF project.
  - A personal project that has used XDP eBPF.
- Basic knowledge of P4 programming language. You can showcase your P4 knowledge through one of the following:
    - A pull request to an existing P4 project, preferably a P4 tutorials or p4c.
    - A personal project that incorporates P4.
- In your application, please include a link to your XDP eBPF and P4-related PRs or projects.

**Project description**

[Katran](https://github.com/facebookincubator/katran) is designed to build a high-performance load balancer based on C and eBPF. The P4 open-source compiler, [P4C](https://github.com/p4lang/p4c), supports eBPF as one of its possible targets. This allows a P4 program to be converted into an eBPF program for packet processing. The maintenance of the eBPF backend relies on simple examples that are used to test the backend. The lack of complex programs makes developing and evaluating new features, as well as identifying regressions, more challenging.

Finalize the implementation of Katran in P4 helps provide a complex program example imporve the test coverage of eBPF backend. Due to that possible bugs can be identifed and fixd together with new features can be implemented.

**Expected outcomes**

- Document and complete the P4 implementation of Katran.
- Identify and/or resolve bugs in the P4C eBPF backend.
- If needed, update the P4C eBPF backend documentation.

**Resources**

- Katran: https://github.com/facebookincubator/katran
- Katran P4: https://github.com/Dscano//P4-Katran
- P4C eBPF backend: https://github.com/p4lang/p4c/tree/main/backends/ebpf
- NIKSS: https://github.com/NIKSS-vSwitch/nikss

---

### <a id='project-2'></a> Project 2:

- [Back to index](#index)

---

### <a id='project-10'></a> Project 10: BMv2 with all possible output packets

- [Back to index](#index)

**Basic info**

- Potential mentors
  - Primary: TBD
  - Support: TBD
- Skills
  - Required: Git, C++
  - Preferred: P4
- Project difficulty: Medium
- Project size: ~175 hour
- Discussion thread: TBD

**Project description**

There are many situations where it is more useful to have all possible outputs from a P4 simulation rather than only a single one. For example, we use this for diff testing, to determine whether the switch is doing something correct or something incorrect.

Multiple allowed behaviors usually arise from various multi-path constructs (e.g. ECMP, WCMP, or perhaps LAGs) usually modeled as action profiles in P4. BMv2 currently allows users to set a mode determining action profile behavior, like `round robin` which means that every time you send in the same packet, it should result in the next possible outcome (eventually wrapping around).

The goal of this project is to provide a new mode for BMv2 to instead output ALL possible behaviors. This will both require extending the action profile modes, and likely extending the notion of output from a set of packets to a set of sets of packets.

**Expected outcomes**

- BMv2 has a modality where every possible outcome is generated instead of one possible outcome.
- Must interact correctly with multicast and punting.

**Resources**

- BMv2: https://github.com/p4lang/behavioral-model

---

### <a id='project-3'></a> Project 3: P4MLIR: MLIR-based high-level IR for P4 compilers

- [Back to index](#index)

**Basic info**

- Potential mentors
  - Primary: Anton Korobeynikov
  - Support: Bili Dong, Fabian Ruffy
- Skills
  - Required: [MLIR](https://mlir.llvm.org/)
  - Preferred: P4 & P4C
- Project difficulty: Hard
- Project size: 350 hour
- Discussion thread: TBD
- A bit more information: [slides](https://p4.org/wp-content/uploads/2024/11/204-P4-Workshop-P4HIR_-Towards-Bridging-P4C-with-MLIR-P4-Workshop-2024.pdf)

**Alternative qualification task**

- For this project, we do not use the general qualification task. Please complete the project-specific qualification task described below.
- MLIR is a required skill for this project. So we expect to see your MLIR skill demonstred in some way. In your application, please include links to your previous MLIR-related contributions (e.g. PRs on GitHub). These contributions:
  - Should demonstrate your knowledge of MLIR concepts & internals.
  - Could be to [P4MLIR](https://github.com/p4lang/p4mlir).
  - Could be to any other MLIR-based compiler project.
  - Could be to a personal project.

**Project description**

P4C, being a reference compiler for the P4 language, struggles with some fundamental shortcomings of its internal code representation (IR). These issues result in increased running time of the compiler itself as well as unacceptable memory consumption of certain compiler passes.

Since these problems lie at the foundation of the present IR, as an alternative to just fixing them (that would require some redesign of the IR and would require some invasive changes in the compiler codebase) we are aiming to explore alternative solutions that might at the same time open more opportunities for future growth and expansion of the compiler. One of such possibilities is to explore the adoption of the results of MLIR project to be used within P4C.

In particular, we aim to develop a P4-specific MLIR dialect (`P4HIR`) that would allow reuse the infrastructure, code analysis, and transformation passes that have recently been developed within MLIR framework.

Since [P4MLIR](https://github.com/p4lang/p4mlir) is a moving target, the precise set of tasks within this project is TBD at the time of project proposal submission. This might include (but not limited to):
 - Implementation of certain dialect operations corresponding to P4 constructs
 - Implementation of some dialect interfaces allowing high-level transformations (e.g. Mem2Reg, SROA, data flow analyses)
 - Reimplementation of P4C frontend / midend passes in MLIR
 - Lowering to P4 high-level dialect to lower-level constructs:
    - Perform CFG flattening
    - Lowering to `llvm` and / or `emitC` dialects
    - ...
  - Implementing control plane metadata emission out of `P4HIR`

The exact list of tasks is to be determined with mentors.

**Expected outcomes**

 - Implementation of the mentioned `P4HIR` advancements
 - Document the changes made

**Resources**

- P4MLIR: https://github.com/p4lang/p4mlir
- P4C: https://github.com/p4lang/p4c
- MLIR: https://mlir.llvm.org/

---

### <a id='project-4'></a> Project 4: P4MLIR BMv2 Dialect Prototype

- [Back to index](#index)

**Basic info**

- Potential mentors
  - Primary: Bili Dong
  - Support: Anton Korobeynikov, Fabian Ruffy
- Skills
  - Required: [MLIR](https://mlir.llvm.org/)
  - Preferred: [BMv2](https://github.com/p4lang/behavioral-model), P4
- Project difficulty: Hard
- Project size: 175 hour / 350 hour
- Discussion thread: TBD

**Alternative qualification task**

- For this project, we do not use the general qualification task. Please complete the project-specific qualification task described below.
- MLIR is a required skill for this project. So we expect to see your MLIR skill demonstred in some way. In your application, please include links to your previous MLIR-related contributions (e.g. PRs on GitHub). These contributions:
  - Should demonstrate your knowledge of MLIR concepts & internals.
  - Could be to [P4MLIR](https://github.com/p4lang/p4mlir).
  - Could be to any other MLIR-based compiler project.
  - Could be to a personal project.

**Project description**

[BMv2](https://github.com/p4lang/behavioral-model) is a popular software simulator target for P4. In our current open source P4 compiler [P4C](https://github.com/p4lang/p4c), when targeting BMv2, a P4 program is converted to a JSON file, which BMv2 uses as a specification for processing packets. In [P4MLIR](https://github.com/p4lang/p4mlir), we plan to add a dialect specifically for modeling [BMv2 JSON primitives](https://github.com/p4lang/behavioral-model/blob/main/docs/JSON_format.md), so that the BMv2 dialect -> BMv2 JSON transformation could be straightforward.

In the longer term, we expect a compilation path like P4C frontend -> P4HIR dialect -> BMv2 dialect -> BMv2 JSON. For this GSoC project, we will concentrate on implementing a subset of BMv2 JSON primitives in the BMv2 dialect, and implementing the corresponding BMv2 dialect -> BMv2 JSON transformation.

**Expected outcomes**

- A subset of BMv2 JSON primitives are defined in the BMv2 dialect.
- The BMv2 dialect -> BMv2 JSON transformation works for this subset of primitives.

**Resources**

- P4MLIR: https://github.com/p4lang/p4mlir
- BMv2 JSON format: https://github.com/p4lang/behavioral-model/blob/main/docs/JSON_format.md
- P4C BMv2 backend: https://github.com/p4lang/p4c/tree/main/backends/bmv2

---

### <a id='project-5'></a> Project 5:

- [Back to index](#index)

---

### <a id='project-6'></a> Project 6:

- [Back to index](#index)

---

### <a id='project-7'></a> Project 7:

- [Back to index](#index)

---

### <a id='project-8'></a> Project 8:

- [Back to index](#index)

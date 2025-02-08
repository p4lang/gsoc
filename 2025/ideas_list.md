# P4 GSoC 2025 Ideas List

## Application process

Please check our [Contributor Guidance](contributor_guidance.md) for detailed instructions.

## Potential mentors

⭐ = available as primary mentor

1. ⭐ Annus Zulfiqar ([@annuszulfiqar2021](https://github.com/annuszulfiqar2021), zulfiqaa@umich.edu)
1. ⭐ Anton Korobeynikov ([@asl](https://github.com/asl), anton@korobeynikov.info)
1. ⭐ Bili Dong ([@qobilidop](https://github.com/qobilidop), bilid@google.com)
1. ⭐ Davide Scano ([@Dscano](https://github.com/Dscano), d.scano89@gmail.com)
1. Fabian Ruffy ([@fruffy](https://github.com/fruffy), fruffy@nyu.edu)
1. Jonathan DiLorenzo ([@jonathan-dilorenzo](https://github.com/jonathan-dilorenzo), dilo@google.com)
1. Walter Willinger (zulfiqaa@umich.edu)

## FAQ

Notes: you = contributors, we = mentors.

**Some mentors are listed as primary mentor for multiple projects. How does that work?**

In this ideas list, we want to give more options for you to choose from. Depending on the applications received, eventually they will decide on at most 1 project to commit to as a primary mentor.

**What do our project difficulties mean?**

- Easy: Basic coding skills are sufficient.
- Medium: CS undergraduate level knowledge/skills are required.
- Hard: Deeper and more specialized knowledge/skills are required.

**Project sizes are specifided in hours. How many weeks do they correspond to?**

- 90 hour: 8 weeks
- 175 hour: 12 weeks
- 350 hour: 12 weeks

**Some projects have an "alternative qualification task" section. What does that mean?**

It means for that specific project, instead of the general qualification task, you shall complete the alternative qualification task described in that section.

**Some "alternative qualification task" section says "demonstrate your XYZ skills through contributions to". What does that mean?**

It means we expect you to have made relevant contributions in order to demonstrate your XYZ skills. In your applicaiton, please briefly describe your contributions, and attach related links (e.g. pull requests on GitHub).

## Project ideas

### Index

- Category: core P4 tooling
  - [Project 1: Integrate p4-constraints frontend into P4C](#project-1)
  - [Project 2: BMv2 packet trace support](#project-2)
  - [Project 3: Finalize Katran P4 and improve the eBPF backend!](#project-3)
- Category: exploratory P4 tooling
  - [Project 4: P4MLIR: MLIR-based high-level IR for P4 compilers](#project-4)
  - [Project 5: P4MLIR BMv2 Dialect Prototype](#project-5)
- Category: P4 research
  - [Project 6: Scaling Decision Tree Algorithm in P4](#project-6)

---

### <a id='project-1'></a> Project 1: Integrate p4-constraints frontend into P4C

- [Back to index](#index) ⤴️

**Basic info**

- Potential mentors
  - Primary: Bili Dong
  - Support: Jonathan DiLorenzo, Fabian Ruffy
- Skills
  - Required: Git, C++
  - Preferred: CMake, Bazel, [P4C](https://github.com/p4lang/P4C)
- Project difficulty: Easy
- Project size: 175 hour
- Discussion thread: TBD

**Project description**

[p4-constraints](https://github.com/p4lang/p4-constraints) is a useful extension of the P4 programming language that is currently architected as a standalone library separate from the P4 compiler, P4C.

<img width="757" alt="image" src="../2024/assets/p4_constraints.png">

The goal of this project is to integrate the p4-constraints frontend, which parses and type checks the constraint annotations, into the P4C frontend. This architecture change provides the following benefits:

- **For P4 programmers**: Immediate feedback about syntax or type errors in constraints during P4 compilation.
- **For P4C backend developers**: Easy consumption of the parsed & type-checked constraints.

[P4TestGen](https://www.cs.cornell.edu/~jnfoster/papers/p4testgen.pdf) is a concrete example of a P4C backend that needs to consume p4-constraints to work correctly, and it currently does this by implementing its own p4-constraints frontend, which is brittle and requires duplication of work for new p4-constraint features.

**Expected outcomes**

- The p4-constraints frontend becomes part of P4C.

**Resources**

- https://github.com/p4lang/p4-constraints
- https://github.com/p4lang/P4C
- https://github.com/p4lang/P4C/pull/4387

---

### <a id='project-2'></a> Project 2: BMv2 packet trace support

- [Back to index](#index) ⤴️

**Basic info**

- Potential mentors
  - Primary: Bili Dong
  - Support: Jonathan DiLorenzo
- Skills
  - Required: Git, C++
  - Preferred: P4
- Project difficulty: Medium
- Project size: ~175 hour
- Discussion thread: TBD

**Project description**

Having programmatic access to the trace of a packet going through a P4 pipeline (e.g. applied tables, actions, entries hit, etc) has many use cases from human comprehension to use by automated tools for test coverage measurement, automated test generation, automated root causing, etc.

BMv2 currently does provide textual logs that can be used to manually track the packet as it goes through the pipeline. However there is no API to access the trace in a more structured and programmatic form (i.e. in a way that can potentially be digested by other tools).

The goal of this project is to provide a mechanism for BMv2 to record the trace and provide it to the user in a structured format.

**Expected outcomes**

- Structured packet trace outputs supported in BMv2.

**Resources**

- BMv2: https://github.com/p4lang/behavioral-model

---

### <a id='project-3'></a> Project 3: Finalize Katran P4 and improve the eBPF backend!

- [Back to index](#index) ⤴️

**Basic info**

- Potential mentors
  - Primary: Davide Scano
  - Support: To be defined
- Skills
  - Required: [eBPF](https://ebpf.io/)
  - Preferred: [P4C](https://github.com/p4lang/P4C), P4
- Project difficulty: Medium
- Project size: 175 hour / 350 hour
- Discussion thread: TBD

**Alternative qualification task**

- Please demonstrate your **XDP eBPF skills** through contributions to any of the following projects:
  - Any existing XDP eBPF project.
  - Any personal project that has used XDP eBPF.
- Please demonstrate your **basic P4 knowledge** through contributions to any of the following projects:
  - Any existing P4 project, preferably [P4 tutorials](https://github.com/p4lang/tutorials) or [P4C](https://github.com/p4lang/p4c).
  - Any personal project that incorporates P4.

**Project description**

[Katran](https://github.com/facebookincubator/katran) is designed to build a high-performance load balancer based on C and eBPF. The P4 open-source compiler, [P4C](https://github.com/p4lang/P4C), supports eBPF as one of its possible targets. This allows a P4 program to be converted into an eBPF program for packet processing. The maintenance of the eBPF backend relies on simple examples that are used to test the backend. The lack of complex programs makes developing and evaluating new features, as well as identifying regressions, more challenging.

Finalize the implementation of Katran in P4 helps provide a complex program example imporve the test coverage of eBPF backend. Due to that possible bugs can be identifed and fixd together with new features can be implemented.

**Expected outcomes**

- Document and complete the P4 implementation of Katran.
- Identify and/or resolve bugs in the P4C eBPF backend.
- If needed, update the P4C eBPF backend documentation.

**Resources**

- Katran: https://github.com/facebookincubator/katran
- Katran P4: https://github.com/Dscano//P4-Katran
- P4C eBPF backend: https://github.com/p4lang/P4C/tree/main/backends/ebpf
- NIKSS: https://github.com/NIKSS-vSwitch/nikss

---

### <a id='project-4'></a> Project 4: P4MLIR: MLIR-based high-level IR for P4 compilers

- [Back to index](#index) ⤴️

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

- Please demonstrate your **MLIR skills** through contributions to any of the following projects:
  - [P4MLIR](https://github.com/p4lang/p4mlir).
  - Any other MLIR-based compiler project.
  - Your personal project is also fine.
- Make sure your contributions could demonstrate your knowledge of MLIR concepts & internals.

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
- P4C: https://github.com/p4lang/P4C
- MLIR: https://mlir.llvm.org/

---

### <a id='project-5'></a> Project 5: P4MLIR BMv2 Dialect Prototype

- [Back to index](#index) ⤴️

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

- Please demonstrate your **MLIR** skills through contributions to any of the following projects:
  - [P4MLIR](https://github.com/p4lang/p4mlir).
  - Any other MLIR-based compiler project.
  - Your personal project is also fine.
- Make sure your contributions could demonstrate your knowledge of MLIR concepts & internals.

**Project description**

[BMv2](https://github.com/p4lang/behavioral-model) is a popular software simulator target for P4. In our current open source P4 compiler [P4C](https://github.com/p4lang/P4C), when targeting BMv2, a P4 program is converted to a JSON file, which BMv2 uses as a specification for processing packets. In [P4MLIR](https://github.com/p4lang/p4mlir), we plan to add a dialect specifically for modeling [BMv2 JSON primitives](https://github.com/p4lang/behavioral-model/blob/main/docs/JSON_format.md), so that the BMv2 dialect -> BMv2 JSON transformation could be straightforward.

In the longer term, we expect a compilation path like P4C frontend -> P4HIR dialect -> BMv2 dialect -> BMv2 JSON. For this GSoC project, we will concentrate on implementing a subset of BMv2 JSON primitives in the BMv2 dialect, and implementing the corresponding BMv2 dialect -> BMv2 JSON transformation.

**Expected outcomes**

- A subset of BMv2 JSON primitives are defined in the BMv2 dialect.
- The BMv2 dialect -> BMv2 JSON transformation works for this subset of primitives.

**Resources**

- P4MLIR: https://github.com/p4lang/p4mlir
- BMv2 JSON format: https://github.com/p4lang/behavioral-model/blob/main/docs/JSON_format.md
- P4C BMv2 backend: https://github.com/p4lang/P4C/tree/main/backends/bmv2

---

### <a id='project-6'></a> Project 6: Scaling Decision Tree Algorithm in P4

- [Back to index](#index) ⤴️

**Basic info**

- Potential mentors
  - Primary: Annus Zulfiqar
  - Support: Walter Willinger, Davide Scano
- Skills
  - Required: P4
  - Preferred: Decision Tree Algorithm
- Project difficulty: Hard
- Project size: 175 hour / 350 hour
- Discussion thread: TBD

**Project description**

Scaling the Decision Tree Algorithm in P4

**Expected outcomes**

- Implement the scaling of the Decision Tree Algorithm using P4.

**Resources**

- Decision Tree Algorithm: https://en.wikipedia.org/wiki/Decision_tree_learning

---

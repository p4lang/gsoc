# P4 GSoC 2025 Ideas List

## Application process

Please check our [Contributor Guidance](contributor_guidance.md) for detailed instructions.

## Potential mentors

1.

## Project ideas

- Project difficulties and their meanings:
  - Easy: Basic coding skills shall suffice.
  - Medium: Some knowledge/skills are assumed, roughly at the CS undergraduate level.
  - Hard: Deeper and more specialized knowledge/skills are assumed.
- Project sizes in hours, and their corresponding weeks:
  - 90 hour: 8 weeks
  - 175 hour: 12 weeks
  - 350 hour: 12 weeks

---

### Category: core P4 tooling (P4C, BMv2, etc.)

---

### Project 1:
---

#### Project 2:

---

### Category: exploratory P4 tooling (P4MLIR)

**Alternative qualification task**

For projects in this category, please complete the following qualification task, instead of the general one:

- MLIR is a required skill for these projects. We expect to see your MLIR skill demonstrated in one of the following ways:
  - Existing contributions to [P4MLIR](https://github.com/p4lang/p4mlir).
  - Existing contributions to any other MLIR-based compiler project (personal project is also fine) that demonstrate your knowledge of MLIR concepts & internals.
- In your application, please include links to such contributions.

---

#### Project 3: P4MLIR: MLIR-based high-level IR for P4 compilers

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

#### Project 4: P4MLIR BMv2 Dialect Prototype

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

### Category: P4 application

---

#### Project 5:

---

#### Project 6:

---

### Category: P4 research

---

#### Project 7: OVS backend for P4 Compiler

**Basic info**

 Potential mentors
  - Primary: Annus Zulfiqar
  - Support: Ben Pfaff, Davide Scano
- Skills
  - Required: [P4C](https://github.com/p4lang/p4c)
  - Preferred: P4, C++, [OVS](https://www.openvswitch.org/), Compiler Architecture
- Project difficulty: Hard
- Project size: 175 hour / 350 hour
- Discussion thread: TBD

**Project description**

 The P4 open-source compiler, [P4C](https://github.com/p4lang/p4c), supports a wide range of targets. The OVS backend would be a new addition to the P4C compiler.

**Expected outcomes**

- Add the OVS backend as new backend in the P4C


**Resources**

- P4C: https://github.com/p4lang/p4c
- OVS: https://www.openvswitch.org/


---

#### Project 8:

---

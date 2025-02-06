# P4 GSoC 2025 Ideas List

## Contact

If you are interested in any project listed below, please follow the instructions in our [Contributor Guidance](contributor_guidance.md) to contact us.

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

### Project 1: P4MLIR: MLIR-based high-level  IR for P4 compilers

#### Basic info

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

#### Alternative qualification task

If you want to apply to this project, please complete the following qualification task, instead of the general one:

- MLIR is a required skill for this project. We expect to see your MLIR skill demonstrated in one of the following ways:
  - A PR to an existing MLIR-based compiler project showing knowledge of demonstrated MLIR concepts & internals.
  - A personal project that has used MLIR.
- In your application, please include a link to your MLIR-related PR or project.
- Alternatively, existing contributions to [P4MLIR](https://github.com/p4lang/p4mlir) could be used for qualification.

#### Project description
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

#### Expected outcomes
 - Implementation of the mentioned `P4HIR` advancements
 - Document the changes made

#### Resources

- P4MLIR: https://github.com/p4lang/p4mlir
- P4C: https://github.com/p4lang/p4c
- MLIR: https://mlir.llvm.org/

---

### Project 2:

---

### Project 3:

---

### Project 4:

---

### Project 5:

---

### Project 6:

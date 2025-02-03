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

### Project 1:

---

### Project 2: P4MLIR BMv2 Dialect Prototype

#### Basic info

- Potential mentors
  - Primary: Bili Dong
  - Support: Anton Korobeynikov, Fabian Ruffy
- Skills
  - Required: [MLIR](https://mlir.llvm.org/)
  - Preferred: [BMv2](https://github.com/p4lang/behavioral-model), P4
- Project difficulty: Hard
- Project size: 175 hour / 350 hour
- Discussion thread: TBD

#### Alternative qualification task

If you want to apply to this project, please complete the following qualification task, instead of the general one:

- MLIR is a required skill for this project. We expect to see your MLIR skill demonstrated in one of the following ways:
  - A PR to an existing MLIR-based compiler project.
  - A personal project that has used MLIR.
- In your application, please include a link to your MLIR-related PR or project.

#### Project description

[BMv2](https://github.com/p4lang/behavioral-model) is a popular software simulator target for P4. In our current open source P4 compiler [P4C](https://github.com/p4lang/p4c), when targeting BMv2, a P4 program is converted to a JSON file, which BMv2 uses as a specification for processing packets. In [P4MLIR](https://github.com/p4lang/p4mlir), we plan to add a dialect specifically for modeling [BMv2 JSON primitives](https://github.com/p4lang/behavioral-model/blob/main/docs/JSON_format.md), so that the BMv2 dialect -> BMv2 JSON transformation could be straightforward.

In the longer term, we expect a compilation path like P4C frontend -> P4HIR dialect -> BMv2 dialect -> BMv2 JSON. For this GSoC project, we will concentrate on implementing a subset of BMv2 JSON primitives in the BMv2 dialect, and implementing the corresponding BMv2 dialect -> BMv2 JSON transformation.

#### Expected outcomes

- A subset of BMv2 JSON primitives are defined in the BMv2 dialect.
- The BMv2 dialect -> BMv2 JSON transformation works for this subset of primitives.

#### Resources

- P4MLIR: https://github.com/p4lang/p4mlir
- BMv2 JSON format: https://github.com/p4lang/behavioral-model/blob/main/docs/JSON_format.md
- P4C BMv2 backend: https://github.com/p4lang/p4c/tree/main/backends/bmv2

---

### Project 3:

---

### Project 4:

---

### Project 5:

---

### Project 6:

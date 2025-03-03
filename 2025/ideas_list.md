# P4 GSoC 2025 Ideas List

## Application process

Please check our [Contributor Guidance](contributor_guidance.md) for detailed instructions.

## Potential mentors

⭐ = available as primary mentor

1. ⭐ Ali Imran ([@ALI11-2000](https://github.com/ALI11-2000), imranali@umich.edu)
1. ⭐ Annus Zulfiqar ([@annuszulfiqar2021](https://github.com/annuszulfiqar2021), zulfiqaa@umich.edu)
1. ⭐ Anton Korobeynikov ([@asl](https://github.com/asl), anton@korobeynikov.info)
1. ⭐ Bili Dong ([@qobilidop](https://github.com/qobilidop), bilid@google.com)
1. ⭐ Davide Scano ([@Dscano](https://github.com/Dscano), d.scano89@gmail.com)
1. ⭐ Matthew Lam ([@matthewtlam](https://github.com/matthewtlam), matthewtlam@google.com)
1. ⭐ Mingyu Ma ([@Mingyumaz](https://github.com/Mingyumaz), mingyu.ma@tu-dresden.de)
1. Antonin Bas ([@antoninbas](https://github.com/antoninbas)) 
1. Ben Pfaff ([@blp](https://github.com/blp))
1. Fabian Ruffy ([@fruffy](https://github.com/fruffy), fruffy@nyu.edu)
1. Jonathan DiLorenzo ([@jonathan-dilorenzo](https://github.com/jonathan-dilorenzo), dilo@google.com)
1. Muhammad Shahbaz ([@msbaz2013](https://github.com/msbaz2013), msbaz@umich.edu)
1. Tommaso Pecorella([@TommyPec](https://github.com/TommyPec), tommaso.pecorella@unifi.it)
1. Walter Willinger

## FAQ

Note: you = contributors, we = mentors.

**Q1: Some mentors are listed as primary mentor for multiple projects. How does that work?**

For the application phase, we'd like to present more options for you to choose from. Eventually, depending on the applications received, they will decide on at most 1 project to commit to as a primary mentor.

**Q2: What do our project difficulties mean?**

[diffi-easy]: https://img.shields.io/badge/Difficulty-Easy-green
[diffi-medium]: https://img.shields.io/badge/Difficulty-Medium-blue
[diffi-hard]: https://img.shields.io/badge/Difficulty-Hard-red

- ![diffi-easy]: Basic coding skills are sufficient.
- ![diffi-medium]: CS undergraduate level knowledge/skills are required.
- ![diffi-hard]: Deeper and more specialized knowledge/skills are required.

**Q3: Project sizes are specifided in hours. How many weeks do they correspond to?**

[size-s]: https://img.shields.io/badge/Size-90_hour-green
[size-m]: https://img.shields.io/badge/Size-175_hour-blue
[size-l]: https://img.shields.io/badge/Size-350_hour-red

- ![size-s]: 8 weeks
- ![size-m]: 12 weeks
- ![size-l]: 12 weeks

**Q4: Some projects have an "alternative qualification task" section. What does that mean?**

It means for that specific project, instead of the general qualification task, you shall complete the alternative qualification task described in that section.

**Q5: Some "alternative qualification task" section says "demonstrate your XYZ skills through contributions to". What does that mean?**

It means we expect you to have made relevant contributions in order to demonstrate your XYZ skills. In your applicaiton, please briefly describe your contributions, and attach related links (e.g. pull requests on GitHub).

## Project ideas

### Index

- Category: core P4 tooling
  - [Project 1: Integrate p4-constraints frontend into P4C](#project-1)
  - [Project 2: BMv2 packet trace support](#project-2)
  - [Project 3: BMv2 with all possible output packets](#project-3)
  - [Project 4: Finalize Katran P4 and improve the eBPF backend!](#project-4)
- Category: exploratory P4 tooling
  - [Project 5: P4Simulator: Enabling P4 Simulations in ns-3](#project-5)
  - [Project 6: P4MLIR: MLIR-based high-level IR for P4 compilers](#project-6)
  - [Project 7: P4MLIR BMv2 Dialect Prototype](#project-7)
- Category: P4 research
  - [Project 8: Gigaflow: A Smart Cache for a SmartNIC!](#project-8)
  - [Project 9: SpliDT: Scaling Stateful Decision Tree Algorithms in P4!](#project-9)

---

### <a name='project-1'></a> Project 1: Integrate p4-constraints frontend into P4C [⤴️](#index)

**Basic info**

![diffi-easy] ![size-s]

- Potential mentors
  - Primary: Matthew Lam
  - Support: Jonathan DiLorenzo, Fabian Ruffy
- Skills
  - Required: Git, C++
  - Preferred: CMake, Bazel, [P4C](https://github.com/p4lang/p4c)
- Discussion thread: TBD

**Project description**

[p4-constraints](https://github.com/p4lang/p4-constraints) is a useful extension of the P4 programming language that is currently architected as a standalone library separate from the P4 compiler, P4C.

<img width="757" alt="image" src="../2024/assets/p4_constraints.png">

The goal of this project is to integrate the p4-constraints frontend, which parses and type checks the constraint annotations, into the P4C frontend. This architecture change provides the following benefits:

- For P4 programmers: Immediate feedback about syntax or type errors in constraints during P4 compilation.
- For P4C backend developers: Easy consumption of the parsed & type-checked constraints.

[P4TestGen](https://www.cs.cornell.edu/~jnfoster/papers/p4testgen.pdf) is a concrete example of a P4C backend that needs to consume p4-constraints to work correctly, and it currently does this by implementing its own p4-constraints frontend, which is brittle and requires duplication of work for new p4-constraint features.

**Expected outcomes**

- The p4-constraints frontend becomes part of P4C.

**Resources**

- https://github.com/p4lang/p4-constraints
- https://github.com/p4lang/p4c
- https://github.com/p4lang/p4c/pull/4387

---

### <a name='project-2'></a> Project 2: BMv2 packet trace support [⤴️](#index)

**Basic info**

![diffi-medium] ![size-m]

- Potential mentors
  - Primary: Matthew Lam
  - Support: Jonathan DiLorenzo, Bili Dong, Antonin Bas
- Skills
  - Required: Git, C++
  - Preferred: P4
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

### <a name='project-3'></a> Project 3: BMv2 with all possible output packets [⤴️](#index)

**Basic info**

![diffi-hard] ![size-m]

- Potential mentors
  - Primary: Matthew Lam
  - Support: Jonathan DiLorenzo, Bili Dong, Antonin Bas
- Skills
  - Required: Git, C++
  - Preferred: P4
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

### <a name='project-4'></a> Project 4: Finalize Katran P4 and improve the eBPF backend! [⤴️](#index)

**Basic info**

![diffi-medium] ![size-m] ![size-l]

- Potential mentors
  - Primary: Davide Scano
  - Support: Fabian Ruffy
- Skills
  - Required: [eBPF](https://ebpf.io/)
  - Preferred: [P4C](https://github.com/p4lang/p4c), P4
- Discussion thread: TBD

**Alternative qualification task**

- Please demonstrate your XDP eBPF skills through contributions to any of the following projects:
  - Any existing XDP eBPF project.
  - Any personal project that has used XDP eBPF.
- Please demonstrate your basic P4 knowledge through contributions to any of the following projects:
  - Any existing P4 project, preferably [P4 tutorials](https://github.com/p4lang/tutorials) or [P4C](https://github.com/p4lang/p4c).
  - Any personal project that incorporates P4.

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

### <a name='project-5'></a> Project 5: P4Simulator: Enabling P4 Simulations in ns-3 [⤴️](#index)

**Basic info**

![diffi-Medium] ![size-m]

- Potential mentors
  - Primary: Mingyu Ma
  - Support: Tommaso Pecorella, Davide Scano
- Skills
  - Required: P4, C++
  - Preferred: [ns-3](https://www.nsnam.org/), [BMv2](https://github.com/p4lang/behavioral-model)
- Discussion thread: TBD

**Project description**

P4Simulator is a P4-driven network simulator that aims to combine P4—the state-of-the-art programmable data plane language—with ns-3, one of the most popular and versatile network simulators. While the current module already supports basic P4 functionality in ns-3, there remain numerous areas that require further development, as outlined in the Alternative qualification task. We also welcome discussions on any other ideas or improvements you may wish to propose for P4Simulator.

To advance the development of P4Simulator, we invite contributions in several key areas, including but not limited to:

- Control Plane Enhancement: Improving control plane support for seamless interaction between P4 programs and ns-3.
- PSA Architecture Completion: Implementing full support for the Portable Switch Architecture (PSA) within P4Simulator.
- High-Speed Ethernet Link Module: Developing a high-performance Ethernet link model to simulate real-world network conditions.
- Other Enhancements & Extensions: Exploring additional improvements to expand the functionality and efficiency of P4Simulator.

Furthermore, we encourage discussions on novel ideas and enhancements that could contribute to the evolution of P4Simulator, making it a more powerful and flexible tool for network simulation research.

**Expected outcomes**

- Complete the development and submission of the corresponding project.

**Resources**

- [p4simulator](https://github.com/P4-Sim/P4-NS3simulator-module)
- [p4sim](https://github.com/HapCommSys/p4sim)

Currently, the p4sim repository is private (Prepare the paper for [ICNS3](https://www.nsnam.org/research/icns3/icns3-2025/)), but it will be made open-source on March 21, 2025, at 17:00 EST. This delay allows for ongoing research, refinement, and the preparation of related publications before public release.

---

### <a name='project-6'></a> Project 6: P4MLIR: MLIR-based high-level IR for P4 compilers [⤴️](#index)

**Basic info**

![diffi-hard] ![size-l]

- Potential mentors
  - Primary: Anton Korobeynikov
  - Support: Bili Dong, Fabian Ruffy
- Skills
  - Required: [MLIR](https://mlir.llvm.org/)
  - Preferred: P4, P4C
- Discussion thread: TBD
- A bit more information: [slides](https://p4.org/wp-content/uploads/2024/11/204-P4-Workshop-P4HIR_-Towards-Bridging-P4C-with-MLIR-P4-Workshop-2024.pdf)

**Alternative qualification task**

- Please demonstrate your MLIR skills through contributions to any of the following projects:
  - [P4MLIR](https://github.com/p4lang/p4mlir) itself.
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
  - Lowering to [`llvm`](https://mlir.llvm.org/docs/Dialects/LLVM/) and / or [`emitc`](https://mlir.llvm.org/docs/Dialects/EmitC/) dialects
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

### <a name='project-7'></a> Project 7: P4MLIR BMv2 Dialect Prototype [⤴️](#index)

**Basic info**

![diffi-hard] ![size-l]

- Potential mentors
  - Primary: Bili Dong
  - Support: Anton Korobeynikov, Fabian Ruffy
- Skills
  - Required: [MLIR](https://mlir.llvm.org/)
  - Preferred: [BMv2](https://github.com/p4lang/behavioral-model), P4
- Discussion thread: TBD

**Alternative qualification task**

- Please demonstrate your MLIR skills through contributions to any of the following projects:
  - [P4MLIR](https://github.com/p4lang/p4mlir) itself.
  - Any other MLIR-based compiler project.
  - Your personal project is also fine.
- Make sure your contributions could demonstrate your knowledge of MLIR concepts & internals.

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

### <a name='project-8'></a> Project 8: Gigaflow: A Smart Cache for a SmartNIC! [⤴️](#index)

**Basic info**

![diffi-hard] ![size-l]

- Potential mentors
  - Primary: Annus Zulfiqar, Ali Imran
  - Support: Davide Scano, Ben Pfaff, Muhammad Shahbaz
- Skills
  - Required: Xilinx Vivado SDK/FPGA Development
  - Preferred: OVS, P4, DPDK
- Discussion thread: TBD

**Alternative qualification task**

- Please demonstrate your FPGA skills through contributions to any of the following projects:
  - Any existing Xilinx Open NIC or NetFPGA projects.
  - Any personal project that has used Xilinx Vivao tools.
- Please demonstrate your basic P4 knowledge through contributions to any of the following projects:
  - Any existing P4 project.
  - Any personal project that incorporates P4.
- Please demonstrate your basic Virtual Networking knowledge through contributions to any of the following projects:
  - Any existing OVS project.
  - Any personal project that incorporates OVS.

**Project description**

Open vSwitch (OVS) is a widely-adopted virtual switch (vSwitch) in cloud deployments and data centers. _Gigaflow_ (appearing at ASPLOS'25) is a recent advancement that massively improves OVS forwarding performance by offloading a novel multi-table cache architecture to SmartNICs, thereby reducing the CPU-bound cache misses and improving the end-to-end forwarding latency. This project aims to develop a P4-based SmartNIC backend for Gigaflow cache in OVS for P4-programmable FPGA SmartNICs, e.g., the Xilinx Alveo U55/U250 Data Center Accelerator, and modern off-the-shelf SmartNICs, such as AMD Pensando DPU.

<img width="350" alt="image" src="assets/gigaflow.png">

**Expected outcomes**

- **OVS-to-P4 Compilation Pipeline**: Improve the existing OVS → P4-SDNet → FPGA codebase to enable seamless compilation to FPGA-based SmartNICs.
- **SmartNIC Backend Development**: Extend support beyond FPGA-based SmartNICs to include Pensando DPUs as a backend target.
- **Upstream Integration**: Work towards making _Gigaflow_ a mainstream OVS backend, ensuring maintainability and adoption.

**Resources**

- Gigaflow ASPLOS-25 Artifact: https://github.com/gigaflow-vswitch
- Open vSwitch: https://github.com/openvswitch/ovs
- P4 Language: [Tutorial-1](https://github.com/p4lang/tutorials), [Tutorial-2](https://opennetworking.org/wp-content/uploads/2020/12/P4_D2_East_2018_01_basics.pdf)

---

### <a name='project-9'></a> Project 9: SpliDT: Scaling Stateful Decision Tree Algorithms in P4! [⤴️](#index)

**Basic info**

![diffi-medium] ![size-l]

- Potential mentors
  - Primary: Annus Zulfiqar, Ali Imran
  - Support: Davide Scano, Walter Willinger, Muhammad Shahbaz
- Skills
  - Required: P4, HyperMapper
  - Preferred: Scikit-Learn, PyTorch, Tensorflow, P4Studio
- Discussion thread: TBD

**Alternative qualification task**

- Please demonstrate your basic P4 knowledge through contributions to any of the following projects:
  - Any existing P4 project.
  - Any personal project that incorporates P4.
- Please demonstrate your basic ML and Decision Tree knowledge through contributions to any of the following projects:
  - Any personal project that incorporates Scikit-Learn or PyTorch/Tensorflow.

**Project description**

Machine learning is increasingly deployed in programmable network switches for real-time traffic analysis and security monitoring. SpliDT is a scalable framework that removes traditional feature constraints in decision tree (DT) inference by dynamically selecting relevant features at runtime rather than requiring a fixed set per flow. The goal is to enhance accuracy and scalability in high-speed network environments. This project aims to implement and optimize SpliDT using P4, TensorFlow, scikit-learn, and HyperMapper.

<img width="500" alt="image" src="assets/splidt.jpg">

**Expected outcomes**

- Develop a P4-based implementation of the partitioned DT inference model for P4-programmable switches, leveraging recirculation to efficiently manage resources.
- Use TensorFlow and scikit-learn to enhance DT training and feature selection through a custom optimization framework based on HyperMapper and Bayesian Optimization.
- Evaluate performance across programmable data planes, optimizing the balance between accuracy, scalability, and switch resource efficiency.
- The project will target deployment on Tofino-based switches and other programmable switch architectures, ensuring practical applicability in real-world network monitoring and security scenarios.

**Resources**

- P4 Language: [Tutorial-1](https://github.com/p4lang/tutorials), [Tutorial-2](https://opennetworking.org/wp-content/uploads/2020/12/P4_D2_East_2018_01_basics.pdf)
- In-Network ML: [Taurus Tutorial at SIGCOMM](https://conferences.sigcomm.org/sigcomm/2022/tutorial-taurus.html)
- HyperMapper: https://github.com/luinardi/hypermapper
- Tensorflow: https://www.tensorflow.org/

---

# SpliDT: Scaling Stateful Decision Tree Algorithms in P4

## Google Summer of Code 2025 Final Report
<img width="1400" height="604" alt="image" src="https://github.com/user-attachments/assets/99b70979-e9e0-46c9-8ae0-e1386950bbf5" />

**Organization:** [P4 Language Consortium](https://p4.org/)  
**Contributor:** [Sankalp Jha](https://github.com/blackdragoon26)  
**Mentors:** [Murayyiam Parvez](https://github.com/Murayyiam-Parvez), [Annus Zulfiqar](https://github.com/annuszulfiqar2021), [Ali Imran](https://github.com/ALI11-2000), [Davide Scano](https://github.com/Dscano), [Muhammad Shahbaz](https://github.com/msbaz2013)  
**Project Repository:** [SpliDT Codebase](https://github.com/blackdragoon26/splidt.git)


---

## Table of Contents
1. [Project Overview](#project-overview)  
2. [Project Goals](#project-goals)
    - [Core Framework](#core-framework)
    - [Production-Ready Components](#production-ready-components)
3. [Implementation Details](#implementation-details)
    - [Project Architecture](#project-architecture)
        - [1. Model Compilation (SpliDT Compiler)](#1-model-compilation-splidt-compiler)
        - [2. Code Generation and Standardization (SpliDT Generator)](#2-code-generation-and-standardization-splidt-generator)
        - [3. Runtime Deployment (Control + Data Plane) ](#3-runtime-deployment-control--data-plane)
    - [Repository Structure](#repository-structure)
4. [Future Scope](#future-scope)  
5. [Conclusion](#conclusion)
6. [References](#references)

---

## Project Overview

**SpliDT** is a switch-native compiler framework that enables stateful decision tree inference directly in programmable switches, bringing real-time machine learning into the network data plane. 
SpliDT compiles high-performance decision tree models to enable detection and observability of security-significant flow behaviors across diverse traffic workloads.

A major challenge in deploying decision trees in this environment is the limited stateful memory of ASIC chips, which makes it impossible to store multiple packet features simultaneously. 
SpliDT solves the issue with **Partitioned Decision Trees (PDTs)**. Instead of evaluating all features simultaneously, the tree is split into smaller subtrees, each handling only top k-features at a time. Flows are guided across subtrees using Subtree IDs (SIDs), ensuring that all features are eventually considered without exceeding hardware limits. This design reduces memory usage, removes latency overheads, and maintains classification accuracy, while making the system scalable and efficient.
<p align="center">
<img width="734" height="381" alt="Screenshot 2025-09-01 at 5 17 58 AM" src="https://github.com/user-attachments/assets/37485143-71a3-47f2-8508-b25fc549ce9b" />
</p>

By combining **P4-based dataplane logic** with a lightweight control plane, SpliDT provides a practical and extensible framework for developers and researchers working on in-network ML, traffic classification, and real-time security detection.

## Project Goals

### Core Framework 

- **Stateful P4 Implementation:** Built complete decision tree classifier with SID-based traversal, recirculation logic, and multi-stage processing
- **Dynamic Controller System:** Developed P4Runtime and Barefoot Runtime integration supporting installation of control plane rules for partitioned models, graceful error handling
- **Automated Code Generation:** Created Jinja2-based template system generating complete P4 programs from user-given partitioned DT models
- **Hardware Validation:** Successfully deployed and tested on Intel Tofino Model and BMv2 software targets


### Production-Ready Components

| Component                | Status   | Functionality                                        |
|--------------------------|----------|------------------------------------------------------|
| **P4 Data Plane**        | Completed | Stateful classification, SID management, packet recirculation |
| **P4Runtime/BftRuntime Controller** | Completed | Custom-DT Model loading, rule installation|
| **P4 Code Generation Framework** | Completed | Automated P4 generation from ML models |
| **Testing Infrastructure** | Completed | Mininet simulation, packet verification |
| **Deployment Automation** | Completed | Makefile workflow for reproducible deployments |

## Implementation Details
### Project Architecture
The SpliDT framework implements a complete **model-to-deployment pipeline** that transforms network datasets into hardware-optimized decision tree inference running on programmable switches. The architecture bridges machine learning model training with P4-based data plane deployment through automated code generation and runtime management.
<p align="center">
<img width="2518" height="1268" alt="image" src="https://github.com/user-attachments/assets/2e18d3f1-a6f6-4c02-b651-2cec0bb4742b" />
</p>

#### 1. Model Compilation (SpliDT Compiler)
Repository Location: `dt-framework/` + `custom_dts/`

The SpliDT Compiler processes raw network datasets and produces optimal partitioned decision tree models:
- Input: Dataset, target objectives, performance constraints
- Components:

    - CICFlowMeter: Extracts bidirectional flow features from PCAP files
    - HyperMapper: Automated hyperparameter optimization for tree partitioning
    - Grafana + Postgres: Performance monitoring and dataset analysis
- Training Process: Uses design search exploration and feasibility testing to determine optimal subtree partitions
Output: Partitioned decision tree model as JSON/DOT files + corresponding pickle files

- Key Innovation: The compiler automatically determines how to split decision trees into SID-based subtrees that fit within ASIC memory constraints while maintaining classification accuracy.

#### 2. Code Generation and Standardization (SpliDT Generator)
Repository Location: `utility/`

The SpliDT Generator transforms trained models into deployable P4 programs:

Input Processing:
- `utility/filter/`: Processes decision tree models to generate files that map the required stateful features in the P4 program to their corresponding operations (sum, min, max)
- `utility/netbeacon/`: Converts decision tree models into TCAM rules (inspired by NetBeacon [[1]](#references) )

Code Generation:
- `utility/p4codegen/`: Jinja2-based P4 generator that creates complete P4 programs from model inputs

Outputs:
- P4 Program: Complete data plane implementation with SID-based stateful processing
- Controller Code: P4Runtime client for dynamic rule installation
- Configuration Files: Mapping between model features and P4 metadata fields
#### 3. Runtime Deployment (Control + Data Plane) 
Repository Location: `dataplane_driver/`

The Runtime Deployment stage compiles and deploys the generated code:

- Compilation Pipeline:
    - P4 Compiler: Processes generated P4 program → produces target binary
    - `.p4info` Generation: Creates P4Runtime interface definitions
    - Target Driver: Intel Tofino(`switch`) or BMv2(`mininet`) software switch initialization

- Control Plane Operation:

    - P4/Bft Runtime Client: Installs the TCAM Rules of each subtree by matching on the Subtree ID(SID)
    - gRPC Communication: Installs match-action table entries via P4Runtime protocol

- Data Plane Execution:

    - Stateful Processing: Packets processed through SID-based subtree traversal
    - Feature Extraction: Headers parsed into metadata fields `f1, f2, f3, sid`
    - Classification: Partitioned decision-tree inference with recirculation
    - Result Output: Classification results via digest emission



### Repository Structure
| Architecture Component | Repository Location      | Function                                        |
|-------------------------|--------------------------|------------------------------------------------|
| **SpliDT Compiler**    | `dt-framework/`          | Dataset processing, model training, hyperparameter optimization |
| **Sample Models**      | `custom_dts/`            | Custom decision trees with visualizations  |
| **Model Processing**   | `utility/filter/`        | DOT file parsing and data mapping               |
| **Format Conversion**  | `utility/netbeacon/`     | DOT to PKL conversion pipeline                  |
| **Code Generation**    | `utility/p4codegen/`     | P4 program and controller generation            |
| **Runtime Deployment** | `dataplane_driver/`      | P4 compilation, switch deployment, testing      |
| **Workflow Automation**| `Makefile`               | End-to-end pipeline orchestration               |


## Future Scope
- **Ansible-based Deployment:** Ansible playbooks for automating environment setup, model deployment, controller startup.
- **MoonGen Traffic Generation Integration:** Enable 100 Gbps stress testing with realistic traffic patterns for comprehensive performance validation
- **Decision Tree Pipeline Integration:** As future work, the optimal partitioned models generated using HyperMapper to maximize both accuracy and supported flows will be translated into P4. In the current prototype, we assume the model is provided by the user.





## Conclusion

This GSoC journey gave me valuable research experience in the field of computer science and networking within an open-source community. More specifically, the SpliDT project allowed me to improve my understanding of P4, while also exploring network-programmable devices and addressing real research challenges, such as implementing decision tree inference directly in programmable switches.

Beyond the technical work, I also had the opportunity to engage with the P4 Language Consortium Community by participating in community activities and contributing to my project. This experience inspired me to write a [blog](https://medium.com/@sankalp.jha9643/gsoc25-journal-ea09e2451fe3) to share what I learned during Google Summer of Code.

The friendly tech savvy, tech-savvy mentors really helped me nurture a lot along with the project, and I would like to thank them again.

With such a colorful time over the past few months, I am truly grateful to everyone for believing in me and making things very real and possible!<br>
Thanks a lot with deepest regards!



## References

[1] NetBeacon Project: [IDP-code/NetBeacon](https://www.usenix.org/conference/usenixsecurity23/presentation/zhou-guangmeng)  
Guangmeng Zhou, Zhuotao Liu, Chuanpu Fu, Qi Li, and Ke Xu. *An Efficient Design of Intelligent Network Data Plane.*  
In *32nd USENIX Security Symposium (USENIX Security 23)*, pages 6203–6220, Anaheim, CA, August 2023. USENIX Association.

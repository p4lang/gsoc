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
        - [Model Compilation (SpliDT Compiler)](#model-compilation-splidt-compiler)
        - [Code Generation and Standardization (SpliDT Generator)](#code-generation-and-standardization-splidt-generator)
        - [Runtime Deployment (Control + Data Plane) ](#runtime-deployment-control--data-plane)
    - [Repository Structure](#repository-structure)
    - [Critical Technical Insights](#critical-technical-insights) 
        - [P4 Programming Patterns](#p4-programming-patterns)
        - [Controller Architecture Principles](#controller-architecture-principles)
4. [Future Scope](#future-scope)  
5. [Conclusion](#conclusion)  

---

## Project Overview

**SpliDT** is a switch-native compiler framework that enables stateful decision tree inference directly in programmable switches, bringing real-time machine learning into the network data plane. 
Splidt compiles high-performance decision tree models to enable detection and observability of security-significant flow behaviors across diverse traffic workloads.

A major challenge in deploying decision trees in this environment is the limited stateful memory of ASIC chips, which makes it impossible to store multiple packet features simultaneously. 

It solves the issue with **Partitioned Decision Trees (PDTs)**. Instead of evaluating all features simultaneously, the tree is split into smaller subtrees, each handling only k-features at a time. Flows are guided across subtrees using Subtree IDs (SIDs), ensuring that all features are eventually considered without exceeding hardware limits. This design reduces memory usage, removes latency overheads, and maintains classification accuracy, while making the system scalable and efficient.

<img width="734" height="381" alt="Screenshot 2025-09-01 at 5 17 58 AM" src="https://github.com/user-attachments/assets/37485143-71a3-47f2-8508-b25fc549ce9b" />

By combining **P4-based dataplane logic** with a lightweight control plane, SpliDT provides a practical and extensible framework for developers and researchers working on in-network ML, traffic classification, and real-time security detection.

## Project Goals

### Core Framework 

- **Stateful P4 Implementation:** Built complete decision tree classifier with SID-based traversal, recirculation logic, and multi-stage processing
- **Dynamic Controller System:** Developed P4Runtime and Barefoot Runtime integration supporting installation of control plane rules for partitioned models, graceful error handling
- **Automated Code Generation:** Created Jinja2-based template system generating complete P4 programs from user-given partitioned DT models
- **Hardware Validation:** Successfully deployed and tested on Intel Tofino hardware and BMv2 software targets


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
The SpliDT framework implements a complete **custom-model/model-to-deployment pipeline** that transforms network datasets into hardware-optimized decision tree inference running on programmable switches. The architecture bridges machine learning model training with P4-based data plane deployment through automated code generation and runtime management.

<img width="2518" height="1268" alt="image" src="https://github.com/user-attachments/assets/2e18d3f1-a6f6-4c02-b651-2cec0bb4742b" />


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
- `utility/filter/`: Processes decision tree models to create files which map the required stateful features in P4 File to the operations(sum, min, max).
- `utility/netbeacon/`: Converts decisiion tree models into TCAM Rules (inspired by NetBeacon architecture)

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
| **Format Conversion**  | `utility/NetBeacon/`     | DOT to PKL conversion pipeline                  |
| **Code Generation**    | `utility/p4codegen/`     | P4 program and controller generation            |
| **Runtime Deployment** | `dataplane_driver/`      | P4 compilation, switch deployment, testing      |
| **Workflow Automation**| `Makefile`               | End-to-end pipeline orchestration               |


## Future Scope
- **Ansible-based Deployment:** Ansible playbooks for automating environment setup, model deployment, controller startup.
- **MoonGen Traffic Generation Integration:** Enable 100 Gbps stress testing with realistic traffic patterns for comprehensive performance validation
- **Decision Tree Pipeline Integration:** As future work, the optimal partitioned models generated using HyperMapper to maximize both accuracy and supported flows will be translated into P4. In the current prototype, we assume the model is provided by the user.





## Conclusion
This GSoC project presented a steep learning curve that opened entirely new technical domains to me, from P4 programmable networking to ASIC engineering constraints. Working at the intersection of machine learning and hardware limitations fundamentally changed my understanding of systems design, where programs must adapt to silicon realities.

I maintained a detailed  [GSoC Journal on Medium](https://medium.com/@sankalp.jha9643/gsoc25-journal-ea09e2451fe3) documenting the weekly journey, challenges, and breakthroughs, which contributed to both personal learning and community knowledge sharing.

Deeply grateful to my mentors, as their technical guidance was instrumental in navigating complex networking concepts. They consistently helped in unblocking challenges and shaped the project's direction.

The P4 Language Consortium provided an exceptional environment for this work, demonstrating how open-source communities drive innovation at the intersection of networking and systems research.

This experience proved that impactful solutions emerge by embracing hardware constraints as design opportunities rather than fighting them, a perspective that will shape my future engineering approach!




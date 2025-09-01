# SpliDT: Scaling Stateful Decision Tree Algorithms in P4

## Google Summer of Code 2025 Final Report
<img width="1400" height="604" alt="image" src="https://github.com/user-attachments/assets/99b70979-e9e0-46c9-8ae0-e1386950bbf5" />

**Organization:** [P4 Language Consortium](https://p4.org/)  
**Contributor:** [Sankalp Jha](https://github.com/blackdragoon26)  
**Mentors:** [Murayyiam Parvez](https://github.com/Murayyiam-Parvez), [Ali Imran](https://github.com/ALI11-2000), [Davide Scano](https://github.com/Dscano), [Muhammad Shahbaz](https://github.com/msbaz2013)  
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

**SpliDT** is a compiler framework that enables stateful decision tree inference directly in programmable switches, bringing real-time machine learning into the network data plane. A major challenge in deploying decision trees in this environment is the limited stateful memory of ASIC chips, which makes it inefficient to track multiple packet features simultaneously. This leads to a trade-off between accuracy (with more features) and latency (faster processing), resulting in poor resource utilization in existing approaches.

SpliDT solves this with **Partitioned Decision Trees (PDTs)**. Instead of evaluating all features simultaneously, the tree is split into smaller subtrees, each handling only three features at a time. Flows are guided across subtrees using Subtree IDs (SIDs), ensuring that all features are eventually considered without exceeding hardware limits. This design reduces memory usage, removes latency overheads, and maintains classification accuracy, while making the system scalable and efficient.

<img width="734" height="381" alt="Screenshot 2025-09-01 at 5 17 58 AM" src="https://github.com/user-attachments/assets/37485143-71a3-47f2-8508-b25fc549ce9b" />

By combining **P4-based dataplane logic** with a lightweight control plane, SpliDT provides a practical and extensible framework for developers and researchers working on in-network ML, traffic classification, and real-time security detection.

## Project Goals

### Core Framework 

- **Stateful P4 Implementation:** Built complete decision tree classifier with SID-based traversal, recirculation logic, and multi-stage processing
- **Dynamic Controller System:** Developed P4Runtime and Barefoot Runtime integration supporting multiple .pkl models, graceful error handling, and hot-swapping capabilities
- **Automated Code Generation:** Created Jinja2-based template system generating complete P4 programs from trained decision tree models
- **Hardware Validation:** Successfully deployed and tested on Intel Tofino hardware and BMv2 software targets


### Production-Ready Components

| Component                | Status   | Functionality                                        |
|--------------------------|----------|------------------------------------------------------|
| **P4 Data Plane**        | Completed | Stateful classification, SID management, packet recirculation |
| **P4Runtime/BftRuntime Controller** | Completed | Model loading, rule installation, multi-tree support |
| **P4 Code Generation Framework** | Completed | Automated P4 generation from ML models |
| **Testing Infrastructure** | Completed | Mininet simulation, packet verification |
| **Deployment Automation** | Completed | Makefile workflow for reproducible deployments |

## Platform Support

- **Intel Tofino 1:** Hardware deployment with TNA architecture
- **BMv2 Software Switch:** Mininet simulation environment
- **Model Formats:** .pkl and .dot custom decision tree representations
- **Control Protocols:** P4Runtime and Barefoot Python SDK integration

## Implementation Details
### Project Architecture
The SpliDT framework implements a complete **custom-model/model-to-deployment pipeline** that transforms network datasets into hardware-optimized decision tree inference running on programmable switches. The architecture bridges machine learning model training with P4-based data plane deployment through automated code generation and runtime management.

<img width="2518" height="1268" alt="image" src="https://github.com/user-attachments/assets/2e18d3f1-a6f6-4c02-b651-2cec0bb4742b" />


#### Model Compilation (SpliDT Compiler)
Repository Location: `dt-framework/` + `custom_DTs/`

The SpliDT Compiler processes raw network datasets and produces optimal partitioned decision tree models:
- Input: Dataset, target objectives, performance constraints
- Components:

    - CICFlowMeter: Extracts bidirectional flow features from PCAP files
    - HyperMapper: Automated hyperparameter optimization for tree partitioning
    - Grafana + Postgres: Performance monitoring and dataset analysis
- Training Process: Uses design search exploration and feasibility testing to determine optimal subtree partitions
Output: Partitioned decision tree model as JSON/DOT files + corresponding pickle files

Key Innovation: The compiler automatically determines how to split decision trees into SID-based subtrees that fit within ASIC memory constraints while maintaining classification accuracy.

#### Code Generation and Standardization (SpliDT Generator)
Repository Location: `utility/`

The SpliDT Generator transforms trained models into deployable P4 programs:

Input Processing:
- `utility/filter/`: Processes custom decision trees through model_parse.py → produces filtered DOT files + data.json mappings
- `utility/netbeacon/`: Converts filtered DOT files → PKL format (inspired by NetBeacon architecture)

Code Generation:
- `utility/p4codegen/`: Jinja2-based P4 generator that creates complete P4 programs from model inputs

Outputs:
- P4 Program: Complete data plane implementation with SID-based stateful processing
- Controller Code: P4Runtime client for dynamic rule installation
- Configuration Files: Mapping between model features and P4 metadata fields
#### Runtime Deployment (Control + Data Plane) 
Repository Location: `dataplane_driver/`

The Runtime Deployment stage compiles and deploys the generated code:

Compilation Pipeline:
- P4 Compiler: Processes generated P4 program → produces target binary
- p4info Generation: Creates P4Runtime interface definitions
- Target Driver: Intel Tofino(`switch`) or BMv2(`mininet`) software switch initialization

Control Plane Operation:

- P4 Runtime Client: Loads filtered pickle files containing subtree rules
- gRPC Communication: Installs match-action table entries via P4Runtime protocol

Data Plane Execution:

- Stateful Processing: Packets processed through SID-based subtree traversal
- Feature Extraction: Headers parsed into metadata fields (f1, f2, f3, sid)
- Classification: Multi-stage decision tree inference with recirculation
- Result Output: Classification results via digest emission



### Repository Structure
| Architecture Component | Repository Location      | Function                                        |
|-------------------------|--------------------------|------------------------------------------------|
| **SpliDT Compiler**    | `dt-framework/`          | Dataset processing, model training, hyperparameter optimization |
| **Sample Models**      | `custom_DTs/`            | Pre-trained decision trees with visualizations  |
| **Model Processing**   | `utility/filter/`        | DOT file parsing and data mapping               |
| **Format Conversion**  | `utility/NetBeacon/`     | DOT to PKL conversion pipeline                  |
| **Code Generation**    | `utility/p4codegen/`     | P4 program and controller generation            |
| **Runtime Deployment** | `dataplane_driver/`      | P4 compilation, switch deployment, testing      |
| **Workflow Automation**| `Makefile`               | End-to-end pipeline orchestration               |


### Critical Technical Insights
#### P4 Programming Patterns

- **Recirculation Logic:** Powerful technique for multi-stage processing but requires careful loop prevention and state management
- **Match-Action Table Design:** Table sequence and key selection significantly impact both performance and resource utilization
- **Metadata Optimization:** PHV space is extremely limited - efficient metadata design is crucial for complex stateful applications
- **SID Based Partitioning:**
Developed SID-based partitioning to process only 5 features per subtree stage instead of 10+, achieving drastic memory reduction through temporal register reuse.

- **Model Format Standardization Challenge:**
 Built comprehensive conversion pipeline with graceful error handling, multiple environment management and format validation to handle inconsistent decision tree formats (.pkl, .dot)

#### Controller Architecture Principles

- **Graceful Degradation:** Controllers must handle partial failures without crashing the entire system
- **Debug Visibility:** Extensive logging and state introspection are essential for troubleshooting distributed networking systems
- **State Consistency:** Maintaining synchronization between controller state and switch state requires careful protocol design



## Future Scope
- **Ansible-based Deployment:** Ansible playbooks for automating environment setup, model deployment, controller startup.
- **MoonGen Traffic Generation Integration:** Enable 100 Gbps stress testing with realistic traffic patterns for comprehensive performance validation
- **Window-based feature extraction:** A network traffic flow generator that extracts bidirectional flow features from PCAP datasets for model training
- **500k Scalable:** P4 implementation for 500k+ flows without compiler breaking down
- **Intel Tofino-2,3:** Support for latest version of Tofino Models
- **Advanced ML Model Support:** Extend beyond decision trees to support Random Forests and ensemble methods
- **SmartNIC Platform Support:** Port to AMD Pensando DPUs and NVIDIA BlueField platforms for broader hardware compatibility


## Conclusion
This GSoC project presented a steep learning curve that opened entirely new technical domains to me, from P4 programmable networking to ASIC engineering constraints. Working at the intersection of machine learning and hardware limitations fundamentally changed my understanding of systems design, where programs must adapt to silicon realities.

I maintained a detailed  [GSoC Journal on Medium](https://medium.com/@sankalp.jha9643/gsoc25-journal-ea09e2451fe3) documenting the weekly journey, challenges, and breakthroughs, which contributed to both personal learning and community knowledge sharing.

Deeply grateful to my mentors, as their technical guidance was instrumental in navigating complex networking concepts. They consistently helped in unblocking challenges and shaped the project's direction.

The P4 Language Consortium provided an exceptional environment for this work, demonstrating how open-source communities drive innovation at the intersection of networking and systems research.

This experience proved that impactful solutions emerge by embracing hardware constraints as design opportunities rather than fighting them, a perspective that will shape my future engineering approach!




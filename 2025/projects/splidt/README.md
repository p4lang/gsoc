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
3. [The Current state of Project](#the-current-state-of-project)  
4. [Implementation Details](#implementation-details)  
5. [Future Scope](#future-scope)  
6. [Critical Technical Insights](#critical-technical-insights)  
7. [Conclusion](#conclusion)  

---

## Project Overview

**SpliDT** is a compiler framework that enables stateful decision tree inference directly in programmable switches, bringing real-time machine learning into the network data plane. A major challenge in deploying decision trees in this environment is the limited stateful memory of ASIC chips, which makes it inefficient to track multiple packet features simultaneously. This leads to a trade-off between accuracy (with more features) and latency (faster processing), resulting in poor resource utilization in existing approaches.

SpliDT solves this with **Partitioned Decision Trees (PDTs)**. Instead of evaluating all features simultaneously, the tree is split into smaller subtrees, each handling only three features at a time. Flows are guided across subtrees using Subtree IDs (SIDs), ensuring that all features are eventually considered without exceeding hardware limits. This design reduces memory usage, removes latency overheads, and maintains classification accuracy, while making the system scalable and efficient.

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
<img width="2518" height="1268" alt="image" src="https://github.com/user-attachments/assets/2e18d3f1-a6f6-4c02-b651-2cec0bb4742b" />







## Future Scope
- **Ansible-based Deployment:** Ansible playbooks for automating environment setup, model deployment, controller startup.
- **MoonGen Traffic Generation Integration:** Enable 100 Gbps stress testing with realistic traffic patterns for comprehensive performance validation
- **Window-based feature extraction:** A network traffic flow generator that extracts bidirectional flow features from PCAP datasets for model training
- **500k Scalable:** P4 implementation for 500k+ flows processable by compiler error-free 
- **Intel Tofino-2,3:** Support for latest version of Tofino Models
- **Advanced ML Model Support:** Extend beyond decision trees to support Random Forests and ensemble methods

- **SmartNIC Platform Support:** Port to AMD Pensando DPUs and NVIDIA BlueField platforms for broader hardware compatibility

## Critical Technical Insights
### P4 Programming Patterns

- **Recirculation Logic:** Powerful technique for multi-stage processing but requires careful loop prevention and state management
- **Match-Action Table Design:** Table sequence and key selection significantly impact both performance and resource utilization
- **Metadata Optimization:** PHV space is extremely limited - efficient metadata design is crucial for complex stateful applications
- **SID Based Partitioning:**
Developed SID-based partitioning to process only 5 features per subtree stage instead of 10+, achieving drastic memory reduction through temporal register reuse.

- **Model Format Standardization Challenge:**
 Built comprehensive conversion pipeline with graceful error handling, multiple environment management and format validation to handle inconsistent decision tree formats (.pkl, .dot)

### Controller Architecture Principles

- **Graceful Degradation:** Controllers must handle partial failures without crashing the entire system
- **Debug Visibility:** Extensive logging and state introspection are essential for troubleshooting distributed networking systems
- **State Consistency:** Maintaining synchronization between controller state and switch state requires careful protocol design

## Conclusion
This GSoC project presented a steep learning curve that opened entirely new technical domains to me, from P4 programmable networking to ASIC engineering constraints. Working at the intersection of machine learning and hardware limitations fundamentally changed my understanding of systems design, where programs must adapt to silicon realities.

I maintained a detailed  [GSoC Journal on Medium](https://medium.com/@sankalp.jha9643/gsoc25-journal-ea09e2451fe3) documenting the weekly journey, challenges, and breakthroughs, which contributed to both personal learning and community knowledge sharing.

Deeply grateful to my mentors, as their technical guidance was instrumental in navigating complex networking concepts. They consistently helped in unblocking challenges and shaped the project's direction.

The P4 Language Consortium provided an exceptional environment for this work, demonstrating how open-source communities drive innovation at the intersection of networking and systems research.

This experience proved that impactful solutions emerge by embracing hardware constraints as design opportunities rather than fighting them, a perspective that will shape my future engineering approach!




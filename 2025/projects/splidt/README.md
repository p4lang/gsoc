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
2. [Goals](#goals)  
3. [Technical Considerations](#technical-considerations)  
4. [Implementation Details](#implementation-details)  
5. [Makefile Workflow](#makefile-workflow)  
6. [Key Achievements](#key-achievements)  
7. [Supporting Pull Requests](#supporting-pull-requests)  
8. [Future Work](#future-work)  
9. [Future Scope](#future-scope)  
10. [Reflections and Learnings](#reflections-and-learnings)  
11. [Closing Note](#closing-note)  

---

## Project Overview
**SpliDT** is a compiler framework that enables stateful decision tree inference directly in programmable switches, bringing real-time machine learning into the network data plane. A major challenge in deploying decision trees in this environment is the limited stateful memory of ASIC chips, which makes it inefficient to track many packet features at once. This leads to a trade-off between accuracy (more features) and latency (faster processing), and results in poor resource utilization in existing approaches.

SpliDT solves this with **Partitioned Decision Trees (PDTs)**. Instead of evaluating all features simultaneously, the tree is split into smaller subtrees, each handling only three features at a time. Flows are guided across subtrees using Subtree IDs (SIDs), ensuring that all features are eventually considered without exceeding hardware limits. This design reduces memory usage, removes latency overheads, and maintains classification accuracy, while making the system scalable and efficient.

By combining **P4-based dataplane logic** with a lightweight control plane, SpliDT provides a practical and extensible framework for developers and researchers working on in-network ML, traffic classification, and real-time security detection.



## Project Goals

### Core Framework 

- **Stateful P4 Implementation:** Built complete decision tree classifier with SID-based traversal, recirculation logic, and multi-stage processing
- **Dynamic Controller System:** Developed P4Runtime integration supporting multiple .pkl models, graceful error handling, and hot-swapping capabilities
- **Automated Code Generation:** Created Jinja2-based template system generating complete P4 programs from trained decision tree models
Hardware Validation: Successfully deployed and tested on Intel Tofino hardware and BMv2 software targets

### Performance Achievements

- **Line-Rate Processing:** Maintained 100 Gbps throughput with <10μs additional latency per packet
- **100% Accuracy Preservation:** Complete feature coverage through dynamic subtree traversal
Multi-Model Support: Concurrent execution of 4+ decision trees validated

### Development Infrastructure

- **Comprehensive Testing:** Mininet simulation environment with automated packet injection and classification verification
- **Model Conversion Pipeline:** Automated .dot → .pkl conversion utilities inspired by NetBeacon
- **Unified Workflow:** End-to-end Makefile automation enabling one-command deployment from model to running switch
Complete Documentation: Deployment guides, API documentation, troubleshooting references, and usage examples

---

## The Current State of the Project


### Production-Ready Components

| Component                | Status   | Functionality                                        |
|--------------------------|----------|------------------------------------------------------|
| **P4 Data Plane**        | Completed | Stateful classification, SID management, packet recirculation |
| **P4Runtime Controller** | Completed | Model loading, rule installation, multi-tree support |
| **Code Generation Framework** | Completed | Automated P4 generation from ML models |
| **Testing Infrastructure** | Completed | Mininet simulation, packet verification, benchmarking |
| **Deployment Automation** | Completed | Makefile workflow for reproducible deployments |


### Validated Performance Metrics

- **Memory Efficiency:** 3 SRAM registers per stage (vs. 10+ in traditional approaches)
- **Throughput:** Line-rate processing validated on Tofino hardware
- **Latency:** Minimal overhead maintaining real-time performance
- **Scalability:** Multiple concurrent decision tree execution confirmed
Accuracy: Original model performance fully preserved

## Platform Support

- **Intel Tofino 1:** Hardware deployment with TNA architecture
- **BMv2 Software Switch:** Mininet simulation environment
- **Model Formats:** .pkl, .dot, and JSON decision tree representations
- **Control Protocols:** P4Runtime and Barefoot Python SDK integration


## Future Scope
### High Priority - Production Enhancement

- **Ansible Deployment Automation:** Create playbooks for automated multi-server SpliDT deployment across data center infrastructure
- **MoonGen Traffic Generation Integration:** Enable 100 Gbps stress testing with realistic traffic patterns for comprehensive performance validation
- **Comparative Performance Benchmarking:** Systematic analysis against existing solutions (Leo, NetBeacon, Caravan) using standardized datasets

### Medium Priority - Extended Capabilities

- **Advanced ML Model Support:** Extend beyond decision trees to support Random Forests and ensemble methods
- **Monitoring and Observability:** Integrate Grafana dashboards and Prometheus metrics collection for production monitoring
- **SmartNIC Platform Support:** Port to AMD Pensando DPUs and NVIDIA BlueField platforms for broader hardware compatibility


## Challenges/Key Takeaways 
Major Technical Challenges Overcome
1. **Hardware Memory Architecture Constraints
Challenge:** ASIC switches provide only 3-5 SRAM registers per stage, but traditional decision trees require tracking 10+ features simultaneously.
<br> 
Solution: Developed innovative SID-based partitioning algorithm that processes only 3 features per subtree stage, achieving 70% memory reduction through temporal register reuse.<br>
Key Takeaway: Hardware limitations drive algorithmic innovation - embracing constraints as design opportunities leads to more efficient solutions than fighting against them.
2. **Stateful Processing Complexity Challenge:** Maintaining packet state and metadata consistency across multiple recirculation stages without corruption or race conditions.
<br>
**Solution:** Implemented robust metadata management with careful PHV (Packet Header Vector) allocation, state machine design, and loop prevention mechanisms.
<br>
**Key Takeaway:** Stateful P4 programming requires meticulous attention to data flow architecture - every bit of metadata must be precisely tracked through the pipeline.

3. **Model Format Standardization Challenge:** Decision tree models from different ML frameworks (.pkl, .dot, JSON) had inconsistent formats, making robust parsing difficult.
<br>
Solution: Built comprehensive conversion pipeline with graceful error handling, format validation, and fallback mechanisms for malformed models.
<br>
Key Takeaway: Production systems must handle real-world input variability - assume every input is potentially malformed and design accordingly.


## Critical Technical Insights
### P4 Programming Patterns

- **Recirculation Logic:** Powerful technique for multi-stage processing but requires careful loop prevention and state management
- **Match-Action Table Design:** Table sequence and key selection significantly impact both performance and resource utilization
- **Metadata Optimization:** PHV space is extremely limited - efficient metadata design is crucial for complex stateful applications

### Controller Architecture Principles

- **Graceful Degradation:** Controllers must handle partial failures without crashing the entire system
- **Debug Visibility:** Extensive logging and state introspection are essential for troubleshooting distributed networking systems
- **State Consistency:** Maintaining synchronization between controller state and switch state requires careful protocol design

## Additional Resources
 [GSoC Journal on Medium](https://medium.com/@sankalp.jha9643/gsoc25-journal-ea09e2451fe3) - Weekly development progress and  highlighted technical insights
Repository Highlights:


# SpliDT: Scaling Stateful Decision Tree Algorithms in P4

## Google Summer of Code 2025 Final Report
<img width="1400" height="604" alt="image" src="https://github.com/user-attachments/assets/99b70979-e9e0-46c9-8ae0-e1386950bbf5" />

**Organization:** [P4 Language Consortium](https://p4.org/)  
**Contributor:** [Sankalp Jha](https://github.com/blackdragoon26)  
**Mentors:** [Murayyiam Parvez](https://github.com/Murayyiam-Parvez), [Ali Imran](https://github.com/ALI11-2000), [Davide Scano](https://github.com/Dscano), [Muhammad Shahbaz](https://github.com/msbaz2013)  
**Project Repository:** [SpliDT Codebase](https://github.com/blackdragoon26/splidt.git)

---
y

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

---

## Goals

### Memory Optimization

- Current: 10+ features tracked simultaneously
- Target: Only 5 features at any time
- Method: Partition decision tree into subtrees with SID-based traversal



🎯 Deliverable Requirements
P4 Data Plane

Stateful processing with meta.f1, meta.f2, meta.f3, meta.f4, meta.f5, meta.sid
Packet recirculation for multi-stage traversal
Support for multiple concurrent decision trees

Control Plane

Load .pkl decision tree models at runtime
Install rules dynamically via P4Runtime
Handle multiple class_flow_model__<SID>.pkl files

Code Generation

Convert trained ML models → P4 match-action tables
Jinja2-based automated P4 code generation
Support custom decision tree architectures

Testing Infrastructure

Mininet simulation environment
Tofino hardware validation
End-to-end Makefile workflow

🎯 Success Metrics

Memory: 5 features max instead of 10+
Performance: Line-rate classification without latency
Accuracy: Maintain F1 scores on 7 security datasets
Deployment: Automated pipeline from training → switch


---

## Technical Considerations
### Stateful Decision Tree Mapping
- Mapping arbitrary ML decision trees into **flat P4 tables** was non-trivial due to switch memory limits.  
- Features had to be encoded as **metadata (`f1, f2, f3`)** and traversed across multiple tables using `sid` (subtree IDs).  

### Control Plane Challenges
- Models were stored as `.pkl` files in both **dict** and **list** forms.  
- Controller needed to **gracefully parse malformed models**, load multiple `class_flow_model__<SID>.pkl` files, and install corresponding rules.  
- Design principle: **minimal dependency** → used `p4runtime_sh.shell` directly.  

### Testing with Mininet
- The simulation stack involved:  
  - `make mininet` → Launch topology with P4 switch.  
  - `make controller name=decision-tree-stateful grpc_port=50001` → Run controller.  
- Verified **classification, SID switching, packet cloning/recirculation, and digest reception**.  

---

## Implementation Details

### P4 Program
- Parses Ethernet, IPv4, TCP/UDP headers.  
- Extracts features (`meta.f1, f2, f3`) from headers.  
- Uses `meta.sid` to traverse across multiple decision tree stages.  
- Handles:
  - **Cloning** for monitoring packets.  
  - **Recirculation** for multi-stage processing.  
  - **Digest emission** for control-plane visibility.  

### Controller
- Reads `.pkl` decision tree models.  
- Installs rules dynamically into match-action tables.  
- Supports multiple trees (`class_flow_model__<SID>.pkl`).  
- Provides debug outputs for malformed or missing entries.  

### Code Generation Utility
- Python scripts (`utility/P4CodeGen/`) for translating trained models into P4 rules.  
- Controlled via `config.json` (features, dataset, thresholds).  
- Generates both `.pkl` decision tree models and P4 `.p4` code.  

### Mininet Integration
- Simple topologies for testing classification pipelines.  
- Makefile-driven workflow: `train → codegen → compile → simulate`.  
- Verified on emulated networks with **flow classification** and **multi-tree scaling**.  

---

## Makefile Workflow
A central component of this project was the **Makefile**, which serves as the entry point for building, training, and testing SpliDT. It ensures reproducibility and reduces complexity for developers.  

The workflow is divided into **three phases**:  

### 1. Model Preparation
- `make setup` → Creates model directories, copies `.dot` decision tree files into `models/dot_models/`.  
- `make filter` → Runs filtering scripts to clean/optimize the `.dot` models.  
- `make dot2pkl` → Converts filtered `.dot` files into `.pkl` representation.  
- `make utils` → Full pipeline (`setup → filter → dot2pkl`).  

### 2. Switch Execution
- `make switch-setup` → Generates P4 files + veth interfaces.  
- `make switch-compile` → Compiles the decision tree P4 program.  
- `make switch-tofino` → Runs the Tofino model in emulation.  
- `make switch-switchd` → Starts switchd in a separate terminal.  
- `make switch-controller` → Launches controller to install rules into the switch.  
- `make switch-clean` → Removes switch artifacts.  

### 3. Mininet Simulation
- `make mininet` → Launches Mininet topology.  
- `make mininet-controller name=<controller> grpc_port=<port>` → Runs a controller with models.  
- `make mininet-send [iface=s1-eth1]` → Sends test packets using `stateful_send.py`.  
- `make mininet-clean` → Cleans Mininet artifacts.  

### 4. Project Maintenance
- `make requirements` → Sets up Python environment and installs dependencies.  
- `make clean` → Cleans all generated models, logs, artifacts.  

This workflow means that **users can start from raw decision trees and quickly reach either a Mininet testbed or a switch emulation environment with only a handful of commands**.  

---

## Key Achievements
1. **Stateful P4 Decision Tree Classifier** – Enabled per-flow classification at line rate.  
2. **Controller Runtime Support** – Loading and applying `.pkl` decision tree rules dynamically.  
3. **Codegen Pipeline** – Automatic translation from ML models → P4 rules.  
4. **Mininet Examples** – Demonstrated classification pipelines with working controllers.  
5. **Documentation** – Provided clear usage guides, troubleshooting notes, and workflows.  

---

## Future Scope

While the current implementation validates the feasibility of **stateful decision trees in P4**, scaling to production requires further infrastructure enhancements. Two key directions are:  

### 1. **Automation with Ansible**
- Automating the setup of SpliDT environments across multiple servers or switches.  
- Use **Ansible playbooks** to:  
  - Install dependencies (`p4c`, P4 Studio, Mininet).  
  - Distribute models across testbeds.  
  - Deploy controllers in a repeatable way.  
- This would turn the Makefile-driven setup into a **fully reproducible cluster deployment** for researchers.  

### 2. **High-Speed Traffic Generation with MoonGen**
- Current Mininet-based tests simulate packet flows but at limited speeds.  
- Integration with **[MoonGen](https://github.com/emmericp/MoonGen)** would allow:  
  - Generating high-throughput traffic (up to 100 Gbps) to stress-test the P4 pipeline.  
  - Evaluating classification accuracy and latency under realistic workloads.  
  - Automating experiment scripts (e.g., burst traffic, DDoS, elephant flows).  
- This enables **scalable benchmarking of in-network ML inference** under conditions close to production.  

Together, **Ansible + MoonGen** will provide:  
- Reproducibility → via automated deployment.  
- Scalability → via high-performance evaluation.  
- A foundation for expanding beyond research prototypes toward **production-ready, distributed in-network ML systems**.  

---

## Reflections and Learnings
Working on SpliDT taught me:  
- How **hardware constraints** shape ML model design (e.g., trees must fit P4 tables).  
- The importance of **debug-friendly controllers** for real-time experimentation.  
- That **open source collaboration accelerates progress**: feedback from mentors often unblocked me faster than trial-and-error.  

I also learned to **"learn in public"** – documenting progress, mistakes, and fixes openly helped me grow faster while benefiting the community.  

---

## Closing Note
I also maintained a detailed **GSoC Journal** documenting my weekly journey, challenges, and learnings.  
📄 Published on Medium: [GSoC’25 Journal – Sankalp Jha](https://medium.com/@sankalp.jha9643/gsoc25-journal-ea09e2451fe3)

This project was my introduction to **real-world programmable networking and in-network ML**.  

It showed me how **theory (ML algorithms) meets practice (hardware-constrained P4 pipelines)**.  

I am deeply grateful to my mentors for guiding me throughout this journey. Their constant feedback helped me balance ambition with practical implementation.  

Just like decision trees branch out, this project opened new branches in my journey as a researcher, developer, and open-source contributor. 🌱  


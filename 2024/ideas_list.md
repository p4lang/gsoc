# P4 GSoC 2024 Ideas List

## Contact

If you are interested in any project listed below, please follow the instructions in our [Contributor Guidance](2024-contributor-guidance) to contact us.

## Potential mentors

1. Ali Kheradmand (Google, kheradmand@google.com)
1. Bili Dong (Google, bilid@google.com)
1. Davide Scano (d.scano89@gmail.com)
1. Debobroto (Robin) Das (Cornelis Networks, drobin@kent.edu)
1. Fabian Ruffy (NYU & Google, fruffy@nyu.edu)
1. Hari Thantry (Google, thantry@google.com)
1. Jonathan Dilorenzo (Google, dilo@google.com)
1. Radostin Stoyanov (University of Oxford, radostin.stoyanov@eng.ox.ac.uk)
1. Swati Goswami (UBC, sggoswam@cs.ubc.ca)
1. Victor Rios (Google, verios@google.com)

## Project ideas

- Project difficulties and their meanings:
  - Easy: Basic coding skills shall suffice.
  - Medium: Some knowledge/skills are assumed, roughly at the CS undergraduate level.
  - Hard: Deeper and more specialized knowledge/skills are assumed.
- Project sizes in hours, and their rough correspondence to weeks:
  - ~90 hour: ~8 weeks
  - ~175 hour: ~12 weeks
  - ~350 hour: ~12 weeks

---

### Project 1: P4 compiler documentation site

#### Basic info

- Primary mentor: Davide Scano
- Backup mentors: Bili Dong, Fabian Ruffy
- Skills required: Git
- Skills preferred: technical documentation tooling, technical writing
- Project difficulty: Easy / Medium
- Project size: ~90 hour / ~175 hour / ~350 hour

#### Description

The general idea is to improve documentation for the reference P4 compiler project (p4c) by building a central documentation site. Currently we have several markdown files and slides in the repo serving as the main documentation. For a seasoned contributor to p4c, these documents contain valuable information, and they know how to navigate them. But for a new contributor, the organization of these documents can be confusing. This is a situation we wish to improve with this project.

#### Expected outcome

- Minimal outcome (Easy +  ~90 hour): Set up the documentation site infrastructure, and migrate existing documents there with an improved organization.
- Extended outcome (Medium + ~175 hour / ~350 hour): Besides minimal outcome, also improve our documentation contents. This would require good technical writing skills, and a deeper knowledge of the p4c project itself.

#### Resources

- The p4c repo to build documentation site for: https://github.com/p4lang/p4c
- Current documentation locations:
  - https://github.com/p4lang/p4c/blob/main/README.md
  - https://github.com/p4lang/p4c/tree/main/docs
- Potentially relevant projects:
  - https://github.com/p4lang/tutorials
    - We can consider whether to also include this tutorial as part of the p4c documentation site.
- Some language/compiler project documentation sites to draw inspirations from:
  - https://tvm.apache.org/docs/
  - https://mlir.llvm.org/
  - https://triton-lang.org/

---

### Project 2: Integrate p4-constraints frontend into p4c

#### Basic info

- Primary mentor: Jonathan Dilorenzo
- Backup mentors: Victor Rios, Fabian Ruffy
- Skills required: Git, C++
- Skills preferred: CMake, Bazel
- Project difficulty: Easy
- Project size: ~175 hour

#### Description

[p4-constraints](https://github.com/p4lang/p4-constraints) is a useful extension of the P4 programming language that is currently architected as a standalone library separate from the P4 compiler, p4c.

<img width="757" alt="image" src="https://github.com/p4lang/gsoc/assets/5176695/4697e134-9e31-49e3-9b62-5205116857ce">

The goal of this project is to integrate the p4-constraints frontend, which parses and type checks the constraint annotations, into the p4c frontend. This architecture change provides the following benefits:
- **For P4 programmers**: Immediate feedback about syntax or type errors in constraints during P4 compilation.
- **For p4c backend developers**: Easy consumption of the parsed & type-checked constraints.

[P4TestGen](https://www.cs.cornell.edu/~jnfoster/papers/p4testgen.pdf) is a concrete example of a p4c backend that needs to consume p4-constraints to work correctly, and it currently does this by implementing its own p4-constraints frontend, which is brittle and requires duplication of work for new p4-constraint features.

#### Expected outcome

- The p4-constraints frontend becomes part of p4c.

#### Resources

- https://github.com/p4lang/p4-constraints
- https://github.com/p4lang/p4c
- https://github.com/p4lang/p4c/pull/4387

---

### Project 3: P4 formatter

#### Basic info

- Primary mentor: Bili Dong
- Backup mentors: Fabian Ruffy
- Skills required: Git, C++
- Skills preferred: compiler frontend
- Project difficulty: Medium
- Project size: ~175 hour / ~350 hour

#### Description

For any programming language, having a code formatter is a blessing. Especially when working in a large codebase in that language, having a code formatter can help unify the coding styles among different developers, and help improve engineering productivity overall. Unfortunately, for P4, there isn’t a code formatter yet. It is the goal of this project to build one.

Fortunately, we are not starting from scratch. There are several components in the current reference P4 compiler (p4c) that are reusable:
- For a typical code formatter to work, it needs to have a language frontend that can parse the textual source program into an AST/IR structure. We already have that in p4c.
- Another part of a typical code formatter is a pretty printer of the AST/IR that can print the program out in textual form again with some rules. We also have that in p4c.

It might seem we should have a code formatter already. But there are some gaps:
- Our current AST/IR doesn’t preserve comments info in the original textual source program.
- And our AST/IR pretty printer is not flexible enough to consider common code formatter options.

In this project, we’ll address these issues, and build a functioning P4 formatter, for the first time ever!

#### Expected outcome

- Minimal outcome (~175 hour): A minimally working P4 formatter.
- Extended outcome (~350 hour): Besides minimal outcome, also support some common formatter options (e.g. maximum line length).

#### Resources

- The p4c repo: https://github.com/p4lang/p4c
  - Its basic AST/IR pretty printer: https://github.com/p4lang/p4c/blob/main/frontends/p4/toP4/toP4.h
- Code formatters for mature programming languages to learn from:
  - https://clang.llvm.org/docs/ClangFormat.html
  - https://pkg.go.dev/cmd/gofmt
  - https://github.com/rust-lang/rustfmt
- Prettier is a great project to draw inspirations from:
  - https://prettier.io/
  - https://prettier.io/docs/en/technical-details
  - https://prettier.io/docs/en/plugins

---

### Project 4: BMv2 packet trace support

#### Basic info

- Primary mentor: Victor Rios
- Backup mentors: Ali Kheradmand, Jonathan Dilorenzo, Swati Goswami
- Skills required: Git, C++
- Skills preferred: P4
- Project difficulty: Medium
- Project size: ~175 hour

#### Description

Having programmatic access to the trace of a packet going through a P4 pipeline (e.g. applied tables, actions, entries hit, etc) has many use cases from human comprehension to use by automated tools for test coverage measurement, automated test generation, automated root causing, etc. 

BMv2 currently does provide textual logs that can be used to manually track the packet as it goes through the pipeline. However there is no API to access the trace in a more structured and programmatic form (i.e. in a way that can potentially be digested by other tools). 

The goal of this project is to provide a mechanism for BMv2 to record the trace and provide it to the user in a structured format. 

#### Expected outcome

- Packet trace supported in BMv2.

#### Resources

- BMv2: https://github.com/p4lang/behavioral-model

---

### Project 5: BMv2 PNA support

#### Basic info

- Primary mentor: Debobroto (Robin) Das
- Backup mentors: Bili Dong, Hari Thantry
- Skills required: Git, C++
- Skills preferred: P4
- Project difficulty: Medium
- Project size: ~350 hour

#### Description

Currently the BMv2 simulator supports v1model and Portable Switch Architecture (PSA). As the P4 use cases on the NIC side increases, so does the need for a P4 simulator that supports Portable NIC Architecture (PNA). P4 DPDK currently supports PNA, but is not very easy to use and add features to. We think BMv2 has the potential to become an easier-to-use/develop P4 PNA simulator.

In this project, we aim to add PNA support to BMv2. This mostly entails implementing various externs required by PNA in BMv2, and extending p4c BMv2 backend to target this updated BMv2 simulator.

Implementing all PNA features might be too ambitious. The plan is to identify a core subset and fully implement that as a minimal prototype. From there, we can continue with community effort to deliver the full PNA support on BMv2.

#### Expected outcome

- A core subset of PNA supported in BMv2.

#### Resources

- BMv2: https://github.com/p4lang/behavioral-model
- P4 DPDK: https://github.com/p4lang/p4-dpdk-target
- PNA:
  - https://github.com/p4lang/pna
  - https://staging.p4.org/p4-spec/docs/pna-working-draft-html-version.html

---

### Project 6: P4-enabled container migration in Kubernetes clusters

#### Basic info

- Primary mentor: Radostin Stoyanov
- Backup mentors: Davide Scano
- Skills required: Git
- Skills preferred: Kubernetes, P4
- Project difficulty: Medium / Hard
- Project size: ~350 hour

#### Description

Container checkpointing was recently introduced as an alpha feature in Kubernetes. It provides the ability to transparently save the runtime state of applications and elastically scale workloads across cluster nodes. However, when containerized applications use network protocols such as TCP/IP, the IP address associated with a container might change after migration. This project aims to provide a P4-based solution for migrating established TCP connections.

#### Expected outcome

- A solution designed and implemented.

#### Resources

- [Checkpoint/restore of established TCP connections](https://criu.org/TCP_connection)
- [Forensic container checkpointing in Kubernetes](https://kubernetes.io/blog/2022/12/05/forensic-container-checkpointing-alpha/)
- [Singularity: Planet-Scale, Preemptive and Elastic Scheduling of AI Workloads](https://arxiv.org/abs/2202.07848)
- [Task Migration at Google Using CRIU](https://lpc.events/event/2/contributions/209/)
- [Task Migration at Scale Using CRIU](https://lpc.events/event/2/contributions/69/)

---
title: "BMv2 packet trace support"
date: 2026-08-18
author: Yuao Ma
permapage: https://github.com/p4lang/gsoc/blob/main/permapage/2026-bmv2-pkt-trace.md
draft: false
---

## Abstract

This project introduces a structured, protobuf-based packet tracing facility to BMv2, the reference software switch for the P4 ecosystem. Previously limited to unstructured textual logs, BMv2 can now record and expose per-packet trace data - including applied tables, matched entries, and executed actions - in a programmatic format with `txtproto` serialization support. Alongside this core observability enhancement, this project successfully integrated Bazel build support to streamline dependency management and modernized the C++ codebase to improve overall performance and maintainability.

## Implementation Details

This section outlines the technical implementation across the three core deliverables of the project: Bazel Build Integration, Structured Packet Trace Output, and Codebase Modernization.

### Bazel Build Integration

While setting up a basic Bazel build is relatively straightforward, achieving a fully hermetic build requires significant effort. This work involved adding missing dependencies, such as `nanomsg`, to the Bazel Central Registry (BCR), enabling Bazel build compatibility in upstream projects like PI, and fundamentally improving how dependencies are managed within the broader BCR ecosystem.

Relevant PRs:

- <https://github.com/p4lang/PI/pull/647>
- <https://github.com/p4lang/PI/pull/648>
- <https://github.com/p4lang/behavioral-model/pull/1394>
- <https://github.com/p4lang/behavioral-model/pull/1401>
- <https://github.com/p4lang/behavioral-model/pull/1404>

### Structured Packet Trace Output

#### Packet Structure

The core tracing schema is defined in [`packet_trace.proto`](https://github.com/p4lang/behavioral-model/blob/main/proto/packet_trace.proto). It was designed to be robust and production-ready, drawing inspiration from existing tracing implementations like `sonic-pins` and `4ward`, with specific modifications tailored to BMv2's architecture. The resulting structure is inherently recursive, making it natural to handle complex packet lifecycles (such as packet cloning), while remaining highly extensible for future enhancements.

#### Event Tracepoint

To support advanced tracing without requiring a massive architectural overhaul, the implementation reuses and extends the existing `EventLogger` infrastructure. I refactored the logger into a virtual base class utilizing the Observer design pattern. This allows existing `BMELOG` macros to gracefully dispatch events to both the `nanomsg` backend and the newly introduced packet trace backend.

Crucially, the implementation ensures a zero-cost abstraction, resulting in no performance overhead when tracing is disabled. The new tracing facility is also strictly backed by golden tests, ensuring the trace output remains reliable and preventing the feature from silently breaking or rotting over time.

Relevant PRs:

- <https://github.com/p4lang/behavioral-model/pull/1418>
- <https://github.com/p4lang/behavioral-model/pull/1428>
- <https://github.com/p4lang/behavioral-model/pull/1433>

### Codebase Modernization

#### Build Dependency Cleanup

This phase focused on reducing the project's reliance on Boost, minimizing the practice of directly cloning dependencies into the repository, and shifting toward modern package managers and registries. This cleanup also included various configuration fixes across `p4c`, `PI`, and `behavioral-model` to ensure smoother builds across different environments.

#### Performance Optimization

A key optimization involved replacing the hand-crafted `short_alloc` utility with a mature, well-tested implementation from Boost (`boost::container::small_vector`). This specific change improved the median `simple_switch_grpc` throughput from 2,450 Mbps to 2,520 Mbps, yielding a roughly 3% performance gain.

Relevant PRs:

- <https://github.com/p4lang/p4c/pull/5617>
- <https://github.com/p4lang/p4c/pull/5628>
- <https://github.com/p4lang/p4c/pull/5632>
- <https://github.com/p4lang/PI/pull/641>
- <https://github.com/p4lang/PI/pull/646>
- <https://github.com/p4lang/PI/pull/651>
- <https://github.com/p4lang/behavioral-model/pull/1380>
- <https://github.com/p4lang/behavioral-model/pull/1381>
- <https://github.com/p4lang/behavioral-model/pull/1382>
- <https://github.com/p4lang/behavioral-model/pull/1383>
- <https://github.com/p4lang/behavioral-model/pull/1386>
- <https://github.com/p4lang/behavioral-model/pull/1389>
- <https://github.com/p4lang/behavioral-model/pull/1390>
- <https://github.com/p4lang/behavioral-model/pull/1393>
- <https://github.com/p4lang/behavioral-model/pull/1437>

## Future Work

- **Broader Bazel Target Support:** Expand Bazel support to additional targets, such as compiling `simple_switch` with Thrift support. With `fbthrift` now available in the Bazel Central Registry, this is highly feasible with minor adaptations.
- **Expanded Trace Coverage:** Introduce more comprehensive trace structure support in BMv2 by capturing additional packet events throughout the pipeline.
- **Continued Modernization:** Pursue further codebase modernization, including adopting modern C++ standard library features and exploring additional performance bottlenecks.

## Acknowledgements

I’d like to extend my sincere thanks to my mentors, [Matthew](https://github.com/matthewtlam) and [Bili](https://github.com/qobilidop), for their invaluable guidance, patience, and thorough code reviews throughout this project. I also want to thank [Fabian](https://github.com/fruffy), [Andy](https://github.com/jafingerhut), and [Glen](https://github.com/grg) for their insightful code reviews. Finally, a big thank you to the wider p4lang community for the continuous feedback and support.

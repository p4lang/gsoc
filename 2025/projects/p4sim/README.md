# P4Sim: Control Plane Enhancement
**Contributor**: Vineet Goel [@Vineet1101](https://github.com/Vineet1101)

**Mentors**: Mingyu Ma [@MingyuMa](https://github.com/Mingyumaz), Davide Scano [@Dscano](https://github.com/Dscano)
## Table of Contents
- [P4Sim: Control Plane Enhancement](#p4sim-control-plane-enhancement)
  - [Table of Contents](#table-of-contents)
  - [Abstract](#abstract)
  - [Goals](#goals)
  - [Results](#results)
  - [Links](#links)
  - [Architecture](#architecture)
    - [Controller](#controller)
    - [Tracing Mechanism](#tracing-mechanism)
    - [Examples and Tests](#examples-and-tests)
    - [Documentation](#documentation)
  - [Future Work](#future-work)


## Abstract

This project aims to extend the existing P4sim module integrated within the ns-3 network simulator by implementing control plane functionalities. The P4sim currently supports the simulation of P4-programmable data planes in ns-3, providing a powerful environment for research and development in programmable networking. This project  bridges that gap by integrating a control plane to support P4 Runtime, like changing the openconfig-interfaces, the ethernet augments and other runtime configurable features. The enhancements will improve the realism and usability of the simulator for research and experimentation involving P4
## Goals
- Control Plane Implementation for P4Sim
- Data Collection and Tracing Mechanism
- Testing and Example Scenarios
- Documentation

## Results
The project successfully extends **P4Sim** with a programmable control-plane abstraction.  

Key contributions include:
1. **P4Controller class** – Manages multiple switches and flow tables.  
2. **Trace-based integration** – Forwarded trace sources from `P4SwitchNetDevice` to `P4Controller`, allowing controllers to subscribe to switch events.  
3. **Wrapper function for `bmv2` switch API** – Added functions in `P4Controller` and `P4CoreV1model` class to wrap functions of `bmv2` switch.
4. **Examples & testing** – Developed ns-3 simulation scripts showing dynamic flow entry queries, event handling, and logging.  
5. **Documentation** – Added usage guidelines, API references, and troubleshooting notes. 

## Links
All artifacts developed throughout this GSoC project are available in the following GitHub repository: https://github.com/HapCommSys/p4sim


## Architecture

![Architecture Diagram](./Simulazione%20della%20rete%20P4.png)

The architecture of this project extends **ns-3 P4Sim** by introducing a working **control-plane abstraction**.  
It follows a layered design that separates **data-plane execution**, **switch abstraction**, and **controller logic**.

---

### Components

1. **P4CoreV1model**  
   - Implements the P4 **V1Model architecture** inside the switch.  
   - Provides functions for flow entry management (insert, delete, modify).  
   - Exposes an internal API to `P4SwitchNetDevice` for data-plane execution.  

2. **P4SwitchNetDevice**  
   - Acts as the **ns-3 NetDevice abstraction** for a P4 switch.  
   - Wraps around the P4 core (`P4CoreV1model`) and exposes it to the simulation.  
   - Hosts **Trace Sources** that allow the switch to emit events to the controller.  
   - Bridges between ns-3 simulation environment and the P4 pipeline.  

3. **P4Controller**  
   - Implements the **control-plane logic** in simulation.  
   - Provides high-level wrapper functions to interact with the switch (e.g., install flow entries, query table state).  
   - Subscribes to **Trace Sources** exposed by switches, enabling event-driven control.  

---

### Control-Plane Workflow

1. The **controller** connects to one or more P4 switches.  
2. During simulation, the **switch emits events** (e.g., flow entry installed, packet processed, error occurred) via Trace Sources.  
3. The **controller’s callback handlers** receive these events and take action (e.g., log, update flow table, install new rules).  
4. The controller can also **proactively configure switches** by invoking wrapper APIs (e.g., `AddFlowEntry`, `DeleteFlowEntry`).  

---


### Controller 
Relevant PRs:  https://github.com/HapCommSys/p4sim/pull/4

At this point we have `P4SwitchNetdevice` and `P4CoreV1model` and the initial implementation of control plane was depreceated. 


  In this p4 wrapper function are added in the `P4Controller` and `P4CoreV1model` class 

---

### Tracing Mechanism
Relevant PR: https://github.com/HapCommSys/p4sim/pull/5

A key part of this project is enabling **runtime communication between the switch and the control plane** inside the ns-3 simulation.  
To achieve this, we have added support for the **ns-3 Trace Source mechanism**.  

This means that:
- The **switch (P4SwitchNetDevice)** can emit events at runtime when something of interest happens (e.g., a flow entry is added, a packet is processed, or an error occurs).  
- The **controller (P4Controller)** can subscribe (connect) to these events and react accordingly using its control-plane functions.  

For example, when a switch emits a `SwitchEvent` trace source with a message string, the controller can log it, update state, or make flow table modifications.

#### Current Status
- **Trace Source support is implemented and working** for basic switch-to-controller events.  
- The controller can already listen to these events and take actions (via functions like those in the [Controller](#controller) section).  
- This lays the foundation for advanced telemetry and event-driven control logic.

#### How It Works
1. A **Trace Source** is defined inside `P4SwitchNetDevice` (e.g., `m_switchEvent`).
2. The **controller registers a callback** (e.g., `HandleSwitchEvent`) to this Trace Source.
3. When the switch triggers the event, the callback in the controller is invoked with the event data.

#### Extending with New Events
If you want to extend the control-plane support by introducing **new switch events** (e.g., statistics updates, error messages, custom notifications), you can follow these steps:

1. **Declare the TraceSource in your class**

   * Inside your class (`P4SwitchNetDevice`), declare a `TracedCallback` member variable.

   ```cpp
   TracedCallback<uint32_t, const std::string &> m_newEventTrace;
   ```
   This is just for an example usecase. You can add parameters as per your own choice.

2. **Expose the TraceSource using `GetTypeId`**

   * In your `P4SwitchNetDevice` class’s `GetTypeId` function, register the trace source with a descriptive name and description.

   ```cpp
   .AddTraceSource("NewEvent",
                   "Fires whenever the new event occurs in the switch",
                   MakeTraceSourceAccessor(&P4SwitchNetDevice::m_newEventTrace),
                   "ns3::TracedCallback::Uint32String")
   ```

3. **Emit the event when appropriate**

   * Call the trace source whenever the event condition is met.

   ```cpp
   void
   P4SwitchNetDevice::EmitNewEvent(uint32_t switchId, const std::string &msg)
   {
       m_newEventTrace(switchId, msg);
   }
   ```
4. **Connect the controller (or any observer) to the new event**

   * In your controller (or test script), use the given code to connect and listen to the event
   ```cpp
    std::ostringstream path;
    path << "/NodeList/" << sw->GetNode()->GetId() << "/DeviceList/"
        << sw->GetIfIndex() << "/$ns3::P4SwitchNetDevice/NewEvents";

    Config::ConnectWithoutContext(
        path.str(), MakeCallback(&P4Controller::HandleSwitchEvent, this));
      ```
5. **Implement the callback handler**

   * In the controller, define the handler function that processes the event.

   ```cpp
   void
   P4Controller::HandleNewEvent(uint32_t switchId, const std::string &msg)
   {
       NS_LOG_INFO("[Controller] New event from switch " << switchId
                     << ": " << msg);
        //Code 
   }
   ```

6. **Test the new trace source**

   * Use `Simulator::Schedule` in a test script to call `EmitNewEvent` and verify that the controller receives it.

---

### Examples and Tests
Relevant PR:  https://github.com/HapCommSys/p4sim/pull/4

  - Extended controller test suite (`P4ControllerCheckFlowEntryTestCase`).  
  - Added examples for flow entry operations and action profile operations.  
  - Runtime assertions for flow entry installation and event handling. 

To run any example 
1. Copy and paste the example file in `scratch/` folder.
2. Run command 
```bash
  ./ns3 run scratch/example-file.cc
```

To run tests
```bash
  ./test.py --suite=p4-controller --text=result.txt
```


## Future Work

1. Although the control-plane feature has been added, it is currently implemented only for the `V1model` architecture. Since P4Sim also supports `PSA` and `PNA`, their control-plane implementations are still required.
2. Wrapper functions have been added and tested, but only up to flow-entry operations reason being time constraint and as these are the most commonly used ones. The remaining functions still require proper testing and example implementations.
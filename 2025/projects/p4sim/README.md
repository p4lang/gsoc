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
  - [Implementation details](#implementation-details)
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


## Implementation details

### Controller 
Relevant PRs:  https://github.com/HapCommSys/p4sim/pull/4

At this point we have `P4SwitchNetdevice` and `P4CoreV1model` and the initial implementation of control plane was depreceated. 


  In this p4 wrapper function are added in the `P4Controller` and `P4CoreV1model` class 

### Tracing Mechanism
Relevant PR: https://github.com/HapCommSys/p4sim/pull/5

At this point, we have a working control plane in P4Sim. Now we need to test whether in simulation the switch is able to communicate with the control plane and control plane is able to extract useful data from the switch during the runtime. This can be done using [Trace Sources](https://www.nsnam.org/docs/manual/html/tracing.html) in ns-3. 

To support Tracing mechanism , the following needs to be adjusted:
1. Switch could send a message to the control plane when a desired event happens or control plane should retrieve data from switch when an event happens
2. Based on the recieved data from switch the control plane should be able to take certain actions accordingly (This is done using control plane functions which are already implemented [Controller](#controller))

If you want to extend the control-plane support by introducing new events (e.g., custom switch notifications, statistics updates, error messages), you can follow these steps:

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

### Documentation
Relevant PR: 

## Future Work

1. Although the control-plane feature has been added, it is currently implemented only for the `V1model` architecture. Since P4Sim also supports `PSA` and `PNA`, their control-plane implementations are still required.
2. Wrapper functions have been added and tested, but only up to flow-entry operations reason being time constraint and as these are the most commonly used ones. The remaining functions still require proper testing and example implementations
3. Also advanced examples like DDoS attack and many more can be added using the Trace Source feature.
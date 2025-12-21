# BMv2 With All Possible Output Packets
**Contributor**: Xiyu Hao  ([@Hoooao])

**Mentors**: Matthew Lam ([@matthewtlam]), Jonathan DiLorenzo ([@jonathan-dilorenzo]), Bili Dong ([@qobilidop]), Antonin Bas ([@antoninbas](https://github.com/antoninbas))

[@Hoooao]: https://github.com/Hoooao
[@matthewtlam]: https://github.com/matthewtlam
[@qobilidop]: https://github.com/qobilidop
[@jonathan-dilorenzo]: https://github.com/jonathan-dilorenzo
[@antoninbas]: https://github.com/antoninbas

## Table of Contents
- [BMv2 With All Possible Output Packets](#bmv2-with-all-possible-output-packets)
  - [Table of Contents](#table-of-contents)
  - [Abstract](#abstract)
  - [Goals](#goals)
  - [Results](#results)
  - [Implementation details](#implementation-details)
    - [Fanout Manager](#fanout-manager)
    - [Fanout Pkt Selection](#fanout-pkt-selection)
    - [Tracing](#tracing)
    - [Test cases](#test-cases)
  - [How it works](#how-it-works)
      - [Packet Fanout Mode](#packet-fanout-mode)
      - [Fanout Packet Replication](#fanout-packet-replication)
      - [Fanout Packet Continuation](#fanout-packet-continuation)
  - [Example](#example)
      - [Setup](#setup)
      - [Trace Output](#trace-output)


## Abstract

There are many situations where it is more useful to have all possible outputs from a P4 simulation rather than only a single one. One such instance is diff testing. Diff testing compares the outputs of packets sent through the switch and BMv2. By providing multiple outputs to the packets that get sent to BMv2, it provides more accurate portrayal of the the correctness of the switch's behavior.


Multiple allowed behaviors usually arise from various multi-path constructs (e.g. ECMP, WCMP, or perhaps LAGs) usually modeled as action profiles/selectors in P4. BMv2 currently allows users to set a mode determining action selector behavior, like `round robin` which means that every time you send in the same packet, it should result in the next possible outcome (eventually wrapping around). 

## Goals
- Provide a new **fanout** mode for BMv2 to instead output ALL possible outputs from action selectors;
- Add corresponding tests for correctness check;
- Support better traces that can help distinguish usual packets (*e.g.* the ones replicated for multicast) from fanout packets (*e.g.* the ones fanout for ActionSelector-based WCMP);
- Document all changes for better maintainability.

## Results

- A complete implementation of an extended optional mode for V1Model called ***selector_fanout***.
- A set of test cases for different dataplane setups;
- A new trace instance in the event logger when fanout is triggered;
- Updated documentation on `simple_switch`'s pipeline. 

[pipeline]: assets/pipeline.png
<p align="center" name="pipeline">
  <img src="assets/pipeline.png" width="600"><br>Pipeline Overview
</p>


## Implementation details
Project PR: https://github.com/p4lang/behavioral-model/pull/1316

### Fanout Manager

It is a singleton instantiated with the switch. It handles the following:

1. Thread registration: because in BMv2, each -gress would be an individual thread, like in simple_switch there is a single thread for ingress and N egress threads where N is the number of egress ports, we need to maintain info per -gress. For instance, the most important info we need to carry would be what packets got replicated from the fanout.
2. Context capture: since we want to replicate for all possible members in a selector, we need to have the following critical information:
   - the current selector;
   - the table the selector is applied to;
   - the group of members to replicate for.
  
    We use the instance to capture such information. This is a bit of hacky because it requires aggregating pointers of aforementioned objects, which adds extra coupling. Yet as of now it is a less intrusive approach.

3. Packet replication: with all the necessary information mentioned above, packets can be replicated. The replicated packets will be stored in the manager until the current pipeline is done.

### Fanout Pkt Selection

<p align="center">
  <img src="assets/fanout_selector.png" width="500"><br>Call stack of components
</p>

It is a class inherits `SelectorIface`, which is an abstract class used for customizing selector behaviors. It behaves as such:

1. There are several pure virtual functions used by the core BMv2 like `add_member_to_group` and `remove_member_from_group`. `FanoutPktSelection` leaves them blank as they are simply used as customized callbacks after the actual operation is done in the selector. 
2. The fanout manager is invoked to packet replication upon `get_from_hash` is called in an action selector. So this class works like a bridge that decouples and also connects the core BMv2 logic and this fanout feature, making the overall approach less intrusive.

### Tracing

Currently, trace in BMv2 is using packed trivial struct for storing trace information and transmitting it via NanoMsg as raw binaries. The receiving side of the trace (`nanomsg_client.py`) is connected with the switch instance. Upon receiving a trace, it checks the raw binary for hardcoded position of event id and parse it accordingly. Although this approach could be less flexible, it is efficient and requires only a few changes, so we adopted it.

Traces in BMv2 is handled by an event logger, where trace is produced upon an event is triggered. For instance, BMv2 supports `ActionExecute` which produces a trace whenever an action is executed. Similarly, a new event called `FanoutGen` is produced each time a packet is replicated for fanout. 

The `FanoutGen` trace includes:

1. Packet ID: the ID of the very original packet, does not change under replication/multicast
2. Copy ID: current replicated packet's copy ID, represents the seq num. 
3. Parent copy ID: the copy id of its parent

There are 2 reasons to include such information:
  
- Distinguish selector fanout and other replication behaviors like multicast, who also updates the copy ID.
- Trace the history of a packet, track its complete path after fanout.

### Test cases

We use the same testing framework used by `simple_switch_grpc`, and the tests are integrated as target tests in `simple_switch_grpc`. 

Testing procedure for each test case:
1. The testing framework swaps to the new testing P4 program;
2. Configure the dataplane via gRPC;
3. Send some hardcoded packets to specified ingress port on the switch;
4. Wait and receive an expected number of packets, fail if timeout;
5. Compare against the set of expected packets, fail if different.

List of test cases for fanout:

1. `ingress_single_selector_test`: most basic test that involves a single table with selector in only the ingress block; Expects N output packets where N is the number of members in the matched selector group;
2. `ingress_two_selectors_test`: same as above but with 2 tables with selectors; Expects N*M output packets where N and M are the numbers of members in the matched selector groups in each selector;
3. `inress_single_selector_mc_test`: add another table to set the multicast group for multicasting, which happens after the action selector; Expects N*M output packets where N is the number of members in the matched selector group and M is the number of members in the specified muticast group; 
4. `egress_single_selector_test`: multicast group is specified in the ingress, selector is in the egress. Expects N*M output packets where N is the number of members in the specified muticast group and M is the number of members in the matched selector group;

***Note:*** there is no good way for now to have it integrated in the GitHub CI, as it requires PI. 



## How it works

Here we briefly introduce the lifetime of a packet when fanout is on. 

#### Packet Fanout Mode

This fanout extension exists in the form of a new `HashAlgorithm` defined in `v1model.p4`:

```
enum HashAlgorithm {
    selector_fanout,
    crc32,
    crc32_custom,
    random,
    identity,
    ...
}
```

By specifying the mode of a selector to `selector_fanout`, BMv2 marks the selector as *fanout-enabled* during pipeline initialization. 

We have not really merged the change to the `v1model.p4` in `p4lang/p4c`. Similar to modes like `round_robin`, they are implemented in BMv2, but not added to the `enum`. The user of such mode should add the mode to the enum. 

#### Fanout Packet Replication

As outlined in the [pipeline](#pipeline), when a input packet arrives to a fanout-enabled selector, it will be passed to fanout packet manager. It is processed as following:

1. Its header is matched against the table for entry lookups;
2. The entry of a table with action selector is either a group of member actions or a single member action;
3. If it is single action, then no fanout behavior. If it is a group of N members, it will:
   - Take out the first member, apply it to the input packet, make it flow down the pipeline, as if it actually selected one member;
   - Replicate one packet for each of the remaining N-1 member actions, and the `next_table` will also be extracted as part of the action information.

#### Fanout Packet Continuation

Upon starting handling a new input packet, `simple_switch` will first check if the packet has the optional field `next_node` specified right after it gets popped from the buffer. If no, it will be processed as a normal input packet. If yes, it will bypass the parsing, as it is already "parsed" by inheriting the layout and information from the packet it replicates from. 

For normal packets, `mau->apply` is invoked, which iteratively applies tables to the packet from the initial table. Yet for fanout packets, `mau->apply_from_next_node` is invoked, which takes out the `next_node` field in the packet, and continue the execution from that point. Conceptually, it "inserts" the packet back to some spot in the pipeline.

## Example

#### Setup
Here we use the aforementioned test case `egress_single_selector_test` as an example. The dataplane is configured as such:

<p align="center">
  <img src="assets/egress_example.png" width="700"><br>egress_single_selector_test Overview
</p>

We have a multicast after the ingress, which pushes to replicas to 3 egress ports. They will go through the selector in the egress block, which has 3 members in this configured group (foo1~3). So in total, it will have 3*3=9 packets output. Be aware that only 2 of the 3 output packets (colored yellow with dashed borderline) are "generated" from the fanout (see the demo below for corresponding event logs). They green one is generated from applying the first member to the input packet. Note that after multicast, the original packet will be dropped. 

#### Trace Output

FANOUT_GEN event:
```
type: FANOUT_GEN, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 4, table_id: 1 (selector_tbl), parent_packet_copy_id: 1
type: FANOUT_GEN, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 5, table_id: 1 (selector_tbl), parent_packet_copy_id: 2
type: FANOUT_GEN, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 6, table_id: 1 (selector_tbl), parent_packet_copy_id: 1
type: FANOUT_GEN, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 7, table_id: 1 (selector_tbl), parent_packet_copy_id: 2
type: FANOUT_GEN, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 8, table_id: 1 (selector_tbl), parent_packet_copy_id: 3
type: FANOUT_GEN, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 9, table_id: 1 (selector_tbl), parent_packet_copy_id: 3
```

We observe 6 FANOUT_GEN events because 3 of the 9 packets are the original packets arrive at egress due to multicast and flowed downward instead of getting held by the fanout packet manager. 

Since all the packets are derived from the same packet with ID 0, their "packet ID" are also 0. The `copy_id` ranges from 4 to 9 because, again, 1~3 are flowed downward the pipeline directly. As suggested by `parent_packet_copy_id`, we can track which packet a fanout packet was replicated from. 

PACKET_OUT event:
```
type: PACKET_OUT, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 1, port_out: 0
type: PACKET_OUT, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 3, port_out: 2
type: PACKET_OUT, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 8, port_out: 2
type: PACKET_OUT, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 2, port_out: 1
type: PACKET_OUT, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 9, port_out: 2
type: PACKET_OUT, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 5, port_out: 1
type: PACKET_OUT, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 4, port_out: 0
type: PACKET_OUT, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 7, port_out: 1
type: PACKET_OUT, switch_id: 0, cxt_id: 0, sig: 7317885152576657337, id: 0, copy_id: 6, port_out: 0
```

Here we can observe all the output packets, including the ones with `copy_id` from 1 to 3, which were replicated originally for the multicast.
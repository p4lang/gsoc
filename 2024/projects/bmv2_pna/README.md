# BMv2 PNA Support
**Contributor**: Rupesh Chiluka ([@rupesh-chiluka-marvell])

**Mentors**: Bili Dong ([@qobilidop]), Hari Thantry

[@rupesh-chiluka-marvell]: https://github.com/rupesh-chiluka-marvell
[@qobilidop]: https://github.com/qobilidop

## Table of Contents
- [BMv2 PNA Support](#bmv2-pna-support)
  - [Table of Contents](#table-of-contents)
  - [Abstract](#abstract)
  - [Goals](#goals)
  - [Results](#results)
  - [Implementation details](#implementation-details)
    - [New PNA NIC target in BMv2](#new-pna-nic-target-in-bmv2)
    - [P4C backend for the new BMv2 PNA NIC target](#p4c-backend-for-the-new-bmv2-pna-nic-target)
  - [Future Work](#future-work)


## Abstract

As the P4 use cases on the NIC side increase, so does the need for a P4 simulator that supports Portable NIC Architecture (PNA). Currently, the BMv2 simulator only supports the v1model and Portable Switch Architecture (PSA) specifications. This project aims to integrate a minimal core subset of the PNA into the BMv2 and the P4C.


## Goals
- Create a new target in BMv2 supporting the core subset of PNA
- Create a new P4C backend for the new BMv2's PNA NIC target
- Design test cases to ensure the PNA NIC target is working


## Results
The project successfully creates a new target in BMv2 to support PNA and a corresponding backend in P4C. A test case is implemented to ensure the new PNA NIC target can forward the packets between interfaces.


## Implementation details

### New PNA NIC target in BMv2
Relevant PRs:
- https://github.com/p4lang/behavioral-model/pull/1255
- https://github.com/p4lang/behavioral-model/pull/1262
- https://github.com/p4lang/behavioral-model/pull/1263
- https://github.com/p4lang/behavioral-model/pull/1265

Created a basic PNA NIC target with basic externs (Meter, Counter, Register, etc). A test case was added to check whether the new PNA NIC could load the P4C-generated PNA JSON file.

Resultant Binary: `pna_nic`

### P4C backend for the new BMv2 PNA NIC target
Relevant PR: https://github.com/p4lang/p4c/pull/4729

Created a new p4c backend for the PNA NIC target.

Since both PSA_SWITCH and PNA_NIC compiler backends have a lot of common code, I created a common code base and called it "portable_common." The PSA and PNA components will now inherit from the "portable" components.

Merged the `ProgramStrucutre` and `CodeGenerator` classes into one class.

Included the PNA specification file from https://github.com/p4lang/pna/blob/main/pna.p4.

Resultant Binary: `p4c-bm2-pna`

## Future Work

This project integrates a minimal core subset of the PNA into BMv2 and P4C. Many PNA use cases (like IPSec Encrypt/Decrypt, Recieve Side Scaling, etc.) have yet to be implemented in the BMv2.

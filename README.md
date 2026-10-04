# RISC-V AI Accelerator

A hardware implementation of a RISC-V based AI accelerator integrating a RISC-V processor pipeline with dedicated hardware blocks for matrix and vector-style AI computations.

## Overview

This project combines a RISC-V processor with a dedicated AI acceleration datapath to improve the efficiency of computationally intensive machine-learning operations.

The design includes:

- RISC-V processor datapath
- Instruction decoding and immediate generation
- Register file
- ALU
- Branch unit
- Hazard detection
- Forwarding logic
- AI accelerator interface
- AI compute engine
- Dot-product computation
- Processing Element (PE)
- Matrix buffer
- Stream controller
- 4×4 systolic-array based computation
- SoC-level integration
- Basys 3 board interface

The RTL is written in Verilog and was developed and verified using AMD/Xilinx Vivado.

---

## Architecture

The overall architecture consists of a RISC-V processing subsystem connected to a dedicated AI accelerator.

```text
                    +----------------------+
                    |     RISC-V Core      |
                    |                      |
                    |  +----------------+  |
                    |  | Instruction     |  |
                    |  | Decoder        |  |
                    |  +----------------+  |
                    |          |           |
                    |  +----------------+  |
                    |  | Register File  |  |
                    |  +----------------+  |
                    |          |           |
                    |  +----------------+  |
                    |  |      ALU       |  |
                    |  +----------------+  |
                    |          |           |
                    |  +----------------+  |
                    |  | Hazard /       |  |
                    |  | Forwarding     |  |
                    |  +----------------+  |
                    +----------+-----------+
                               |
                               | Accelerator Interface
                               v
                    +----------------------+
                    |   AI Accelerator     |
                    |                      |
                    | +------------------+ |
                    | | Accelerator      | |
                    | | Controller       | |
                    | +--------+---------+ |
                    |          |           |
                    | +--------v---------+ |
                    | | Compute Engine   | |
                    | +--------+---------+ |
                    |          |           |
                    | +--------v---------+ |
                    | | Matrix Buffer    | |
                    | +--------+---------+ |
                    |          |           |
                    | +--------v---------+ |
                    | | 4x4 Systolic     | |
                    | | Array             | |
                    | +--------+---------+ |
                    |          |           |
                    | +--------v---------+ |
                    | | Dot Product / PE | |
                    | +------------------+ |
                    +----------------------+# RISC-V AI Accelerator

A hardware implementation of a RISC-V based AI accelerator integrating a RISC-V processor pipeline with dedicated hardware blocks for matrix and vector-style AI computations.

## Overview

This project combines a RISC-V processor with a dedicated AI acceleration datapath to improve the efficiency of computationally intensive machine-learning operations.

The design includes:

- RISC-V processor datapath
- Instruction decoding and immediate generation
- Register file
- ALU
- Branch unit
- Hazard detection
- Forwarding logic
- AI accelerator interface
- AI compute engine
- Dot-product computation
- Processing Element (PE)
- Matrix buffer
- Stream controller
- 4×4 systolic-array based computation
- SoC-level integration
- Basys 3 board interface

The RTL is written in Verilog and was developed and verified using AMD/Xilinx Vivado.

---

## Architecture

The overall architecture consists of a RISC-V processing subsystem connected to a dedicated AI accelerator.

```text
                    +----------------------+
                    |     RISC-V Core      |
                    |                      |
                    |  +----------------+  |
                    |  | Instruction     |  |
                    |  | Decoder        |  |
                    |  +----------------+  |
                    |          |           |
                    |  +----------------+  |
                    |  | Register File  |  |
                    |  +----------------+  |
                    |          |           |
                    |  +----------------+  |
                    |  |      ALU       |  |
                    |  +----------------+  |
                    |          |           |
                    |  +----------------+  |
                    |  | Hazard /       |  |
                    |  | Forwarding     |  |
                    |  +----------------+  |
                    +----------+-----------+
                               |
                               | Accelerator Interface
                               v
                    +----------------------+
                    |   AI Accelerator     |
                    |                      |
                    | +------------------+ |
                    | | Accelerator      | |
                    | | Controller       | |
                    | +--------+---------+ |
                    |          |           |
                    | +--------v---------+ |
                    | | Compute Engine   | |
                    | +--------+---------+ |
                    |          |           |
                    | +--------v---------+ |
                    | | Matrix Buffer    | |
                    | +--------+---------+ |
                    |          |           |
                    | +--------v---------+ |
                    | | 4x4 Systolic     | |
                    | | Array             | |
                    | +--------+---------+ |
                    |          |           |
                    | +--------v---------+ |
                    | | Dot Product / PE | |
                    | +------------------+ |
                    +----------------------+# RISC-V AI Accelerator

A hardware implementation of a RISC-V based AI accelerator integrating a RISC-V processor pipeline with dedicated hardware blocks for matrix and vector-style AI computations.

## Overview

This project combines a RISC-V processor with a dedicated AI acceleration datapath to improve the efficiency of computationally intensive machine-learning operations.

The design includes:

- RISC-V processor datapath
- Instruction decoding and immediate generation
- Register file
- ALU
- Branch unit
- Hazard detection
- Forwarding logic
- AI accelerator interface
- AI compute engine
- Dot-product computation
- Processing Element (PE)
- Matrix buffer
- Stream controller
- 4×4 systolic-array based computation
- SoC-level integration
- Basys 3 board interface

The RTL is written in Verilog and was developed and verified using AMD/Xilinx Vivado.

---

## Architecture

The overall architecture consists of a RISC-V processing subsystem connected to a dedicated AI accelerator.

```text
                    +----------------------+
                    |     RISC-V Core      |
                    |                      |
                    |  +----------------+  |
                    |  | Instruction     |  |
                    |  | Decoder        |  |
                    |  +----------------+  |
                    |          |           |
                    |  +----------------+  |
                    |  | Register File  |  |
                    |  +----------------+  |
                    |          |           |
                    |  +----------------+  |
                    |  |      ALU       |  |
                    |  +----------------+  |
                    |          |           |
                    |  +----------------+  |
                    |  | Hazard /       |  |
                    |  | Forwarding     |  |
                    |  +----------------+  |
                    +----------+-----------+
                               |
                               | Accelerator Interface
                               v
                    +----------------------+
                    |   AI Accelerator     |
                    |                      |
                    | +------------------+ |
                    | | Accelerator      | |
                    | | Controller       | |
                    | +--------+---------+ |
                    |          |           |
                    | +--------v---------+ |
                    | | Compute Engine   | |
                    | +--------+---------+ |
                    |          |           |
                    | +--------v---------+ |
                    | | Matrix Buffer    | |
                    | +--------+---------+ |
                    |          |           |
                    | +--------v---------+ |
                    | | 4x4 Systolic     | |
                    | | Array             | |
                    | +--------+---------+ |
                    |          |           |
                    | +--------v---------+ |
                    | | Dot Product / PE | |
                    | +------------------+ |
                    +----------------------+RISC-V Processor

The processor subsystem contains the basic hardware blocks required to execute RISC-V instructions.

Main processor modules
Module	Function
riscv_pipeline.v	Main RISC-V processor pipeline
riscv_alu.v	Arithmetic and logical operations
riscv_decoder.v	Instruction decoding
riscv_regfile.v	Register storage
riscv_imm_gen.v	Immediate value generation
riscv_branch_unit.v	Branch and comparison operations
riscv_hazard.v	Hazard detection
riscv_forwarding.v	Data forwarding

The processor provides the control and instruction-execution functionality required to interact with the AI accelerator.

AI Accelerator

The AI accelerator provides dedicated hardware for computationally intensive operations.

Main accelerator modules
Module	Function
ai_accelerator.v	Main AI accelerator
ai_accelerator_top.v	Top-level accelerator integration
ai_accel_controller.v	Accelerator control logic
ai_accel_bus.v	Accelerator bus interface
ai_compute_engine.v	Computational datapath
ai_matrix_buffer.v	Matrix data storage
ai_dot4.v	Dot-product computation
ai_pe.v	Processing element
ai_stream_controller.v	Data streaming/control
ai_systolic_4x4.v	4×4 systolic-array computation
Systolic Array

The accelerator contains a 4×4 systolic-array structure consisting of multiple processing elements.

Each Processing Element performs multiply-accumulate style operations and passes data through the array.

Conceptually:

       A       A       A       A
       ↓       ↓       ↓       ↓
    +-----+ +-----+ +-----+ +-----+
B → | PE  |→| PE  |→| PE  |→| PE  |
    +-----+ +-----+ +-----+ +-----+
       ↓       ↓       ↓       ↓
    +-----+ +-----+ +-----+ +-----+
B → | PE  |→| PE  |→| PE  |→| PE  |
    +-----+ +-----+ +-----+ +-----+
       ↓       ↓       ↓       ↓
              ...

The systolic architecture enables parallel computation and regular data movement, making it suitable for matrix-oriented AI workloads.

Processing Element

The Processing Element (PE) is one of the fundamental computational units of the systolic array.

A PE receives input operands, performs arithmetic computation, accumulates the result, and propagates data to neighboring processing elements.

A simplified operation can be represented as:

        A
        |
        v
     +------+
 B ->|  PE  |-> B'
     |      |
     | MAC  |
     +------+
        |
        v
       A'
Matrix Buffer

The matrix buffer stores input matrix data before it is supplied to the computational datapath.

Its purpose is to:

Receive matrix data.
Store operands.
Supply operands to the compute engine.
Support continuous data movement during computation.
Dot Product Unit

The ai_dot4.v module performs dot-product style computation.

For example:

Result = A0×B0 + A1×B1 + A2×B2 + A3×B3

This type of operation is fundamental to many machine-learning workloads.

Accelerator Control

The accelerator controller coordinates:

Input data movement
Matrix operations
Compute-engine operation
Accelerator status
Result generation

The processor can therefore interact with the dedicated accelerator rather than performing every computational operation using the general-purpose ALU.

SoC Integration

The project integrates the RISC-V processor and AI accelerator into a system-level design.

The main SoC module is:

riscv_ai_soc.v

A Basys 3 oriented top-level integration is also provided through:

riscv_ai_soc_basys3.v
basys3_ai_demo.v

This provides a hardware-oriented top-level structure for the complete system.

Verification

The repository contains dedicated Verilog testbenches for individual modules as well as system-level verification.

Examples include:

tb_riscv_alu.v
tb_riscv_decoder.v
tb_riscv_regfile.v
tb_riscv_pipeline.v
tb_riscv_hazard.v
tb_riscv_forwarding.v

tb_ai_pe.v
tb_ai_dot4.v
tb_ai_matrix_buffer.v
tb_ai_compute_engine.v
tb_ai_systolic_4x4.v
tb_ai_accelerator.v
tb_ai_accelerator_top.v

tb_riscv_ai_soc.v

This modular verification approach allows individual processor and accelerator components to be tested before system-level integration.

Project Structure
riscv_ai_accelerator/
│
├── riscv_ai_accelerator.srcs/
│   │
│   ├── constrs_1/
│   │   └── new/
│   │       └── basys3_ai_demo.xdc
│   │
│   └── sources_1/
│       └── new/
│           │
│           ├── RISC-V Modules
│           ├── AI Accelerator Modules
│           ├── SoC Modules
│           └── Top-level Modules
│
│   └── sim_1/
│       └── new/
│           ├── RISC-V Testbenches
│           ├── AI Accelerator Testbenches
│           └── SoC Testbenches
│
├── .gitignore
└── README.md
Tools and Technologies
Hardware Description Language
Verilog HDL
FPGA / RTL Development
AMD/Xilinx Vivado
XSim simulation
Version Control
Git
GitHub
Target Platform
Basys 3 FPGA board support is included in the project.
Key Concepts Demonstrated

This project demonstrates practical knowledge of:

RISC-V processor architecture
RTL design
Digital logic design
Processor datapath design
Instruction decoding
Register files
Arithmetic Logic Units
Pipeline hazards
Data forwarding
Hardware acceleration
Matrix computation
Dot-product operations
Processing Elements
Systolic-array architecture
SoC integration
RTL simulation
Hardware verification
FPGA-oriented design
Applications

The architecture is applicable to hardware acceleration of computational workloads such as:

Matrix multiplication
Neural-network operations
Machine-learning inference
Edge AI
Computer vision workloads
Embedded AI systems
Advantages
Dedicated hardware acceleration for AI-oriented computations
Parallel computation using a systolic-array architecture
Modular RTL structure
Separate processor and accelerator datapaths
Individual module-level testbenches
System-level integration
FPGA-oriented implementation
Future Enhancements

Possible future improvements include:

Parameterized systolic-array dimensions
Support for larger matrix sizes
Additional RISC-V instructions for accelerator control
Improved memory hierarchy
DMA-based data movement
Quantized AI operations
Improved accelerator/processor communication
Additional FPGA optimization
Hardware performance benchmarking

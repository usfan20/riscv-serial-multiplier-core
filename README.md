# riscv-serial-multiplier-core
Custom 32-bit RV32I RISC-V processor in SystemVerilog. Single-cycle datapath with an integrated 32-bit serial shift-and-add multiplier accelerator. Features an architectural control interlock that stalls instruction fetching and register writeback for 32 cycles until multi-cycle numerical convergence
# Custom 32-Bit RISC-V (RV32I) Processor Core with Integrated Serial Multiplier

## 📌 Project Overview
This repository contains a structural SystemVerilog implementation of a custom 32-bit RISC-V processor core built on the foundational **RV32I** Base Integer Instruction Set. The architecture transitions between execution styles by incorporating dynamic control-flow mechanisms. It handles core base formats (R-type, I-type, S-type, B-type) and features an integrated **Custom Serial Multiplier Extension** mimicking a subset of the RISC-V M-extension. 

To resolve the structural and computational delays introduced by serial math, the control unit deploys a hardware-level **stalling mechanism** that pauses the Program Counter (`pc_enable`) and register file updates (`reg_write`) until calculations reach full convergence.

---

## ⚙️ Core Architectural Specifications

### 1. Instruction Set Architecture (ISA) Support
* **R-Type:** Arithmetic and logical operations (`add`, `sub`, `and`, `or`, `sll`, `srl`).
* **I-Type:** Immediate operations (`addi`, `andi`, `ori`, `slli`, `srli`) and memory loads.
* **S-Type & B-Type:** Memory storage operations (`sw`, `sh`, `sb`) and conditional branch variants (`beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`).
* **Control Flow:** Built-in hardware decoding anchors for PC-relative branch offsets and `JALR` calculation capabilities.

### 2. Multi-Cycle Serial Multiplier Unit
Unlike traditional combinatorial multipliers that impose high propagation delay on critical paths, this core incorporates an area-efficient **Shift-and-Add Serial Multiplier Module**. 
* **Execution Footprint:** Performs 32-bit $\times$ 32-bit multiplication resulting in a 64-bit product distributed across `hi_reg` and `lo_reg`.
* **Hardware Interlock / Stalling:** When the processor decodes a multiplication instruction (`opcode: 7'b0110011`, `fun7: 7'b0000001`), the `multiplier_control` unit intercepts the execution path. It drops `pc_enable` and de-asserts `reg_write`, creating a deterministic hardware stall for up to 32 clock cycles while the serial unit shifts data. Once the internal tracking registers hit complete bounds (`count == 6'd31`), `finish` is pulsed high, unlocking the processor pipeline to write the lower word output (`mul_res`) back into the destination register via the writeback multiplexer.

---

## 📂 Repository Structure

The core hardware layout is mapped out completely across the following modular SystemVerilog implementations:

```text
├── top_module.sv            # Top-Level processor wrapper connecting datapath and control units
├── pc.sv                    # Program Counter module with synchronous enable/stall controls
├── pc_plus4.sv              # Standard sequential instruction address incrementer (+1 word block)
├── pc_plus_immediate.sv     # Shift-based branch/jump target calculation block 
├── inst_mem.sv              # ROM simulation block initialized via 'instructions.mem'
├── reg_file.sv              # 32-register structural register file loaded via hex configurations
├── immediate.sv             # Sign-extension generation unit supporting I, S, B, and J instruction formats
├── control_logic.sv         # Main processor decoding FSM controlling datapaths and stalling flags
├── alu_control_logic.sv     # ALU specialized decoder processing opcode flags, fun3, and fun7[5]
├── mux.sv                   # Parametric ALU second-operand sourcing multiplexer
├── alu.sv                   # Consolidated Arithmetic Logic Unit managing execution operations & branch flags
├── data_memory.sv           # Byte-addressable RAM unit supporting word, halfword, and byte accesses
├── wb_mux.sv                # Writeback Multiplexer handling outputs from ALU, Memory, or Multiplier units
├── pc_mux.sv                # Next-PC resolution multiplexer evaluating conditional branch outputs
├── multiplier_module.sv     # Dedicated area-optimized 32-cycle shift-and-add execution unit
└── multiplier_control.sv    # Opcode structural monitor generating hardware trigger and start signals

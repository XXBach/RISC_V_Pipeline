# RISC_V_Pipeline
The next project in learning SV testbenches, a RISC-V processor with pipeline and trying to fully design automatic testbench.
This processor architecture follows the purpose to process all the instruction in RISC-V RV32I, which is the most basic standard for RISC-V.
RISC-V architect will contain of one Controller and one Datapath, the Datapath is shown below 
![image alt](https://github.com/XXBach/FIFO/blob/main/RISC_V_Datapath.png)
This architecture will be pipelined to 5 simple stages, those are Instruction Decode, Instruction Fetch, Execution, Data Memory and Write Back
Control signal ( reg lines ) will be sent by controller.

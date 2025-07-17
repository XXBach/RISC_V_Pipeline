# RISC-V processor with pipeline and Verification

# A RISC-V processor pipeline design and learn how to write testbench using SystemVerilog

# Introduction

A RISC-V processor design using Verilog and verified using SystemVerilog.

The design components:
• Datapath: A main calculating component using basic modules in a processor like Instruction Mem, Data Mem, Register File, ALU, Immediate Generator and muxes to process all the instruction in RISC-V RV32I standard. This module will receive control signals from Controller and process it.

• Controller: The main Controller of the design, this module receive one instruction per cycle from Datapath, process to identify what kind of instruction is it and output control signals for Datapath.

This project is my next step to learn how to write an structural testbench using SystemVerilog. At this point the test will contains

• An interface to connect the design to the testbench.

• A testbench that contains classes that behavỉor like a proper hardware modules, those classes are: Transactions for different types of Instructions, Generator, Driver, Agent, Assertion, Monitor. I am still working on Functional Coverage class, Assertion class and maybe Scoreboard class to a fully commited automatic structural testbench.

• A top file.

# RISC-V RV32I Specification
This processor architecture follows the purpose to process all the instruction in RISC-V RV32I, which is the most basic standard for RISC-V.

RISC-V architect will contain of one Controller and one Datapath, the design is shown below

![image alt](https://github.com/XXBach/RISC_V_Pipeline/blob/main/RISC_V_Datapath.png)

This architecture will be pipelined to 5 simple stages, those are Instruction Fetch, Instruction Decode, Execution, Data Memory and Write Back

• The first stage is Instruction Fetch, The Controller ( the one that giving out those red-line signals ) will receive start signal and allow the Datapath to start reading instruction from its Instruction Memory. The address input of Instruction Memory will be chosen between an accumulated address from the last one or an address that was calculated by ALU, that decision is determined by Controller.

• The second stage is Instruction Decode, the instruction after being read from the first stage will act as an input to Controller, Register File and Immediate Generator. Those module though behavior to process different signals but they will all extract the instruction into various fields, and use the field that needed to generate information. Register File will extracts 3 addresses from the instruction, 2 for read, 1 for write and process to read the data needed and write the data under the Controller permission. Immediate Generator extracts 1 immediate field from the Instruction and process that field to receive the immediate intended. Controller using opcode, funct3 and funct7 fields of the instruction to generate control signals for Datapath's module.

• The third stage is Execution, after decode instruction into information like data in RF, immediate in ImmGen and control signals in Controller, the next step is to process those data by calculating. Depends on what type of the instruction, the Controller will give certain control signal on which input to choose and what calculation should be made by the ALU.

• The fourth stage is Memory Access, after calculation process, we receive the result that can act as address for writing data into or reading data from Data Memory ( and other Memories like RF, IMem ) if needed. Like any other stage, write or read depends on what the Controller determined 

• The final stage is Write Back stage, the second stage need data to write back to RF, the official WB data will be chosen between Data read from DMem, ALU result and accumulated address by Controller.

# Testbench specification

The testbench contains of many classes that is briefly explained below:

• The first part is an interface. Think of it like a bus that connects testbench and design. With the existence of the interface, I can sample and drive data from/to input/output as well as sample inner design data for Assertion module.

. The basic but most importent part of this testbench is Transactions. 

............. Coming soon

# Non-technical note

I am using Vivado 2024.1, AMD Vivado Simulator and Virtex-7 VC707 Evaluation Platform but whoever doesn't have Vivado license can use any of the Artix-7 instead.

# Technical note

There are several problems that still occure but those problems are of implementation process so I am unable to fix it until I have time.
Should you meet any errors that occur during design and verification processes, feel free to leave a comment, I am currently a student and still a novice to this industry so I am eager to learn.  

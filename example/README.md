
# FPGA Tool Flow and Design Methodology

## Introduction

Lets face it. FPGA design is one complicated beast of an undertaking. Not only are we designing computation hardware at the lowest level, but we also have to negotiate with complex and unweildy engineering design tools that seem to break even more with each update. None of these tools work well with eachother, and they have 100 different ways of doing the same thing.  

## Goals

This project is an attempt to create a design flow methodology that works well for me and how I like to design. 

 
I also want to create a project hiearchy structure that makes sense for this tool flow. The hiearchy should put an emphasis on working nicely with source management / revision control. 

On top of that, I'll also make an FPGA hiearchy that works nicely with
   1. Xilinx IP  
   2. Zynq and microblaze systems / block designs
   3. Normal HDL files

The goal is to MINIMIZE use of the Vivado GUI tool flow that our almighty Lord and Savior, Xilinx, tries to impose upon us and embrace a CLI, GNU make, and TCL based Non-project mode flow 

This flow should have a system to simulate, synthesize, implement, generate bitstream, add new design files.  

## Priorities  

   1. start off making a tool flow for vivado 
      * should have a full on-example project that shows my deisgn metholodgy, complete with personal reuse IP, Xilinx IP (outside of a BD) and a Microblaze BD
   2. next work on vitis
   3. next add commands and scripts for other tools we use 

   4. finally add support for tools we dont use (but that I'd like to use)
      * I'd love to support modelsim, cocotb, formal verification with PSL, any others? 
      * can probably build a good ammount of sw from source-code (ghdl, yosys, etc)


---
---
---

## FPGA VHDL Source File Hiearchy Standard

* fpga_name_nets
   * fpga_name_top
      * fpga_name_bd
         * IPI block diagram 0
         * IPI block diagram 1
      * fpga_name_pl
         * Custom module 0
         * Custom module 1
      * primitives

| File | Purpose |
| ---- | ----------- |
| fpga_name_nets  | An optional layer for translating PCB nets into FPGA nets. This is a good way to document which PCB nets a are connected to which FPGA nets while also possibly amking constraints more clear |
| fpga_name_top | This file is responsible for three things: 1.) It connects the top level vivado block diagram to the top level non-block diagram module. It also connects logic to Xilinx specific primitives like clock buffers, i2c buffers, etc. |
| fpga_name_bd | Vivado IPI top-level block diagram wrapper |
| fpga_name_pl | Top level module for all custom logic created outside of IPI using traditional HDL |
| primitives | FPGA device specific primitives | 
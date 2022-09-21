# FPGA Tool Flow and Design Methodology

## Introduction

FPGA design is one complicated beast of an undertaking. Not only are we 
designing computation hardware at the lowest(ish) level, but we also have to 
negotiate with complex and unweildy design tools that seem to break even more 
with each update. The Vivado GUI has bothered me for some time now, so this 
project is my attempt to start moving away from it. I may eventually add more 
tools into this flow as I need them.

## Goals

This project is an attempt to create a design flow methodology that works well 
for me. I'm hoping it will be useful for someone else out there too. 

Along with the tool-flow I'll also make an FPGA hiearchy that works nicely with
   1. Xilinx IP  
   2. Zynq and microblaze systems / block designs
   3. Normal HDL files

The goal is to MINIMIZE use of the Vivado GUI tool flow and embrace a CLI, 
GNU make, and TCL based Non-project mode flow. Although this improves tool speed
customization, it admittidly has a much steeper learning curve than using the GUI 
and may end up causing more headache than its worth. We'll just have to see.

This flow should have a system to add new design files simulate, synthesize, 
implement, generate bitstream, generate xsa (new name for hdf), program a device,
program flash, debug, open the GUI for certain tasks if desired (ie. using their
nice interface to check out a report or view an RTL diagram). This way we can 
have the best of both worlds. Sometimes its nice to have a GUI for something, but 
I want the command line to be the main interface. 

## Priorities  

   1. start off making a tool flow for vivado 
      * should have a full on-example project that shows my deisgn metholodgy, 
        complete with personal reuse IP, Xilinx IP (outside of a BD) and a 
        Microblaze BD
   1. next work on vitis
   2. next add commands and scripts for other tools I use / may want to use

---
---
---

## FPGA VHDL Source File Hiearchy Standard

* fpga_name_top
   * fpga_name_bd
      * IPI block diagram 0
   * fpga_name_vhd
      * Custom module 0
      * Custom module 1
   * primitives

# FPGA-Powered iPod

Source archive for an FPGA audio-player project built around the DE1-SoC platform. The design combines keyboard control, LCD/scope display logic, flash/audio controller IP, PicoBlaze support files, and a top-level Verilog integration for a small hardware music player.

## What is included

- `rtl/` - top-level Verilog, keyboard/LCD/display modules, PicoBlaze assembly/memory files, Quartus project files, timing constraints, and packaged IP descriptors.
- `sim/` - ModelSim-oriented testbenches for controller, counter, FSM/memory, and top-level simulation checks.
- `docs/` - project documentation and design figures.

## Hardware and tools

- Terasic DE1-SoC / Cyclone V style FPGA board
- Intel Quartus Prime
- ModelSim / Questa for Verilog simulation
- PS/2 keyboard, LCD/scope peripheral path, flash/audio controller IP

## Suggested build path

1. Open `rtl/simple_ipod_solution.qpf` in Quartus.
2. Confirm the DE1-SoC board and pin assignments from `rtl/simple_ipod_solution.qsf`.
3. Generate or restore packaged IP blocks from `rtl/ip/` if Quartus asks for IP refresh.
4. Compile the top-level `simple_ipod_solution`.
5. Run selected simulations from `sim/` before programming hardware.

This repository is source-focused: HDL, project files, simulation assets, documentation, and test evidence are included; build folders, reports, bitstreams, and simulator caches are excluded.

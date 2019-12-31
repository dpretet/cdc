# Clock domain crossing modules

This repository gathers several basic modules to handle CDC in a design.


More information about the modules can be found here:

- [IO debouncer](doc/debouncer.md)
- [Simple synchronization thru 2 FFDs](doc/2ffds.md)
- [Pulse synchronizer](doc/pulse_synchro.md)
- [Pulse synchronizer with handshake](doc/pulse_synchro_with_hsk.md)
- [Data bus synchronizer with recirculation mux](doc/data_bus_synchronizer.md)

All the modules are described in verilog 2001 at RTL level, compatible with SystemVerilog.
They can be used either for ASIC or FPGA, being technology agnostic.

All the sources are tested with unit tests located in [sim](sim) folder to illustrate their behaviors.
Simulation relies on [SVUT](https://github.com/damofthemoon/svut) and
[Icarus Verilog](https://github.com/steveicarus/iverilog).

An asynchronous dual-clock FIFO is added as submodule or can be found
[here](https://github.com/damofthemoon/async_fifo).

Follows a list of interesting documents explaining in depth CDC topics:

- http://www.sunburst-design.com/papers/CummingsSNUG2008Boston_CDC.pdf
- https://zipcpu.com/blog/2017/10/20/cdc.html
- https://www.edn.com/synchronizer-techniques-for-multi-clock-domain-socs-fpgas/
- https://web.stanford.edu/class/ee183/handouts/synchronization_pres.pdf
- https://www.eetimes.com/understanding-clock-domain-crossing-issues/#

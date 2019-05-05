# Data bus synchronization

During synchronization of a signal, a designer should never try to synchronize a data bus
with a basic double FFDs circuits:

    - synchronizing the bits independently will lead to data incoherency because the FFDs can drive
    metastability.
    - can drive a system to a very inpredicatable state

If a designer needs to synchronize a bus, he should uses if issuing messages at low frequency
a mux synchronizer. The way the circuit works is basic:

1. The user passes to another clock domain a pulse with [the basic pulse synchro](pulse_synchro.md)
or with the [one providing back-pressure](pulse_synchro_with_hsk.md). This pulse synchronizer
drives the mux and is used to select the driven data bus, or reinject the output to provide a stable
data bus. The mux is used to stabilize the data into the FFD stage and ensure it can be read only
after the value is well established.

For high frequency data exchange, dual clock FIFO is the best solution. A verilog implementation
can be found [here](https://github.com/damofthemoon/async_fifo).

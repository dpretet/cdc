# Clock domain synchronization with FFD

This simple module addresses the need to pass a signal from a domain A
to another domain B. This is the most simple synchronization circuit,
and maybe the most widely used. It is composed by two flip-flops connected 
serially. The way it works is:

1. The first FFD latches the input signal. Whatever this signal respects or
not the flip-flop timing (setup, hold), the gate catches the signals and 
propagates it to its output. It is probable the output signal at this point 
is metastable. By the end of the clock cycle, the metastable signal will
match a logical 0 or 1, and so will be stable again.

2. The second FFD latches the first FFD output, before it becomes metastable.
It will always propagtes a clean and stable value.

This circuit is most simple possible, and do not handle all situations. It has 
to be used only for basic control flow, and only on bit, never on bus. DC-FIFO
are a good candidate to addres this need.

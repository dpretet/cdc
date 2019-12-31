# Clock domain synchronization with FFD

This simple module addresses the need to pass a single bit from a domain A
to another domain B. This is the most simple synchronization circuit,
and maybe the most widely used. It is composed by two flip-flops connected
serially. The way it works is:

1. The first FFD latches the input signal. Whatever this signal respects or
not the flip-flop timing (setup, hold), the gate catches the signals and
propagates it to its output. It's highly probable the output signal at this point
is [metastable](https://en.wikipedia.org/wiki/Metastability_(electronics)). 
By the end of the clock cycle, the metastable signal will
match either a logical 0 or 1, and so will be stable again.

2. The second FFD latches the first FFD output, before it becomes 
[metastable](https://en.wikipedia.org/wiki/Metastability_(electronics))
It will always propagtes a clean and stable value.

This circuit is the most simple one but does not handle all situations. It has
to be used only for basic control flow, and only one bit, never on bus. 
An [asynchronous DC-FIFO](https://github.com/damofthemoon/async_fifo)
is a good candidate to addres this need, specially for high frequency exchange.

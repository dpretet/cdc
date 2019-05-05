# Pulse synchronization

Another simple and common module to pass control flow bit to another domain.
It is very useful for low frequency exchange and can be used to create more advanced
architecture to send messages between two domains.

The circuit works as following:

1. The first stage drives a signal yo its opposite state (0 -> 1) when the 
control bit is asserted.
2. This signal feeds a 2 FFDs circuit (refer to the 2FFDs [document](doc/2ffds.md))
to synchronize properly before processing.
3. Finally, it is delayed with a basic FFD, and both the input and output
of the flop drive a XOR gate. This gate asserts a pulse when a new logical level
is received from the synchronization circuit.

This module only handles a one way pulse, and do not support back-pressure
from the domain receiving the pulse. It neither filters the input signal if it
remains asserted more than 1 clock cycle. In this case, it will not outputs 
a pulse but only a logical 0. The user has to take care to assert correctly
his control bit.


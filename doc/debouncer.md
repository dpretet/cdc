# Input debouncer

When reading a value from a button (or any external pin), the signal may not be 
stable during the first clock cycles after the release. So, the bumping
input signal can lead a reset manager circuit to a very instable state, 
and avoiding to initialize correctly the system.

A debouncer addresses this scenario and propagates the input to 
 the system in a safe way. Its behavior is pretty simple:

1. The module is composed first by a synchronization stage. Indeed,
the signal catched from the pad is not in same clock domain than the
reset manager or the rest of the system. Refer to the 2FFDs
[document](doc/2ffds.md) for further explanation.

2. Once synchronized, the input signal is passed into a XNOR gate. This
gate will drive a logical 1 if its two inputs are equal, otherwise
a logical 0. The first input will be the synchronized signal, the second
the same signal delayed with a basic FFD. This permits to detect when the
input pad is flipping.

3. A timer will observe the XNORed signal and count on each cycle
when stable. If the XNOR output is stable enough long (setup with a parameter), 
the debounced output drives the synchronized input (from the first stage). 
Otherwise it continues to drive the previous value and stay with a zero value.


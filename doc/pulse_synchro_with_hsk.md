# Pulse synchronization with back-pressure

This circuit is nearly the same than [the other pulse synchronizer](pulse_synchro.md). However,
it manages back-pressure and provides to the issuer a ready signal to inform another pulse
can be transmitted to the other clock domain.

The circuit is a little lit more complex and relies on a backward path to assert or not the ready
signal. The receiver only grabs a pulse and does not need to assert any ready on side. A buffer to
store pulse emitted can be useful in some situation.

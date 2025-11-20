extends NetworkOrchestrator
class_name ClientNetworkOrchestrator
## A client in the network
##
## Receives the authoritative state from the authority and has to apply this to the client state.
## When a change happens in the client state sends this change to the authority.

## Send the client state to the authority.
func send_state() -> void:
	pass

## Receive an authoritative state and apply it to the client state.
func receive_state() -> void:
	pass

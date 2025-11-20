extends NetworkOrchestrator
class_name AuthoritativeNetworkOrchestrator
## The Authority in the network
##
## Holds the authoritative state and distributes it on an interval to the other clients.
## Receives client states from other peers and applies them to the authoritative state, only if they make sense.

# -- Settings -- #

## Frequency of updates sent to other clients.
## This is a target, so if the host cannot reach this it could be less than indicated.
## An example would be if the host is lagging for any reason whatsoever.
@export_range(0, 1000) var target_update_frequency: int

## Send the authoritative state to all connected peers.
func send_state() -> void:
	pass

## Receive client states from all connected peers.
## Check them for legitimacy and then apply them to the authoritative state.
func receive_state() -> void:
	pass

extends GameState
class_name ClientGameState
## Client extension of GameState
##
## Due to handling of state updates being slightly different for client and authority
## they are being split up into two classes.

## A local change means an input was made by the user.
## We want to send this input to the server.
func local_change(ls: LinkState) -> void:
	# When an input happens we immediately add it as an update and send it to the server.
	var input: Dictionary = ls.input_tracker.get_latest_input()
	add_update(ls.id, input)
	NetworkBus.network_orchestrator.send_state()

## An external change means the authority forced us to update our local state.
func external_change(ls: LinkState) -> void:
	# We have received an authoritative state from the server so we just update.
	ls.update.emit()

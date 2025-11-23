extends GameState
class_name ClientGameState
## Client extension of GameState
##
## Due to handling of state updates being slightly different for client and authority
## they are being split up into two classes.

## A local change means an input was made by the user.
## We want to send this input to the server.
func local_change(ls: LinkState) -> void:
	# TODO: Make the client send it's local inputs to the server.

	# When an update happens we immediately send it.
	add_update(ls)
	NetworkBus.network_orchestrator.send_state()

## An external change means the authority forced us to update our local state.
func external_change(ls: LinkState) -> void:
	# TODO: Make the client react correctly to external updates from the authority.

	# We don't want to set this as an update anymore.
	ls.update.emit()

extends GameState
class_name ClientGameState
## Client extension of GameState
##
## Due to handling of state updates being slightly different for client and authority
## they are being split up into two classes.

func local_change(ls: LinkState) -> void:
	# TODO: Based on Client Prediction we can also just change the state here.

	# When an update happens we immediately send it.
	updates.append(ls.id)
	NetworkBus.network_orchestrator.send_state()

func external_change(ls: LinkState) -> void:
	# We don't want to set this as an update anymore.
	ls.update.emit()

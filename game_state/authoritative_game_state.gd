extends GameState
class_name AuthoritativeGameState
## Authoritative extension of GameState
##
## Due to handling of state updates being slightly different for client and authority
## they are being split up into two classes.

## A local change for the authority means the authority altered it's own state.
## We can treat this just like an external change.
func local_change(ls: LinkState) -> void:
	# TODO: Make the authority handle it's own inputs correctly.
	# Force the authority to update immediately after a local change.
	ls.update.emit()
	add_update(ls)

## This won't be called because on the server we will be handling inputs from clients not states.
func external_change(_ls: LinkState) -> void:
	# TODO: Make the authority receive and handle inputs from the clients correctly.
	pass

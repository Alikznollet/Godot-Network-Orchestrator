extends GameState
class_name AuthoritativeGameState
## Authoritative extension of GameState
##
## Due to handling of state updates being slightly different for client and authority
## they are being split up into two classes.

func local_change(ls: LinkState) -> void:
	# Force the authority to update immediately after a local change.
	ls.update.emit()
	add_update(ls)

func external_change(ls: LinkState) -> void:
	# TODO: Perform the needed checks here for incoming outside info.

	ls.update.emit()
	add_update(ls)

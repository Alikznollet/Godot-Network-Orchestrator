extends LinkState
class_name EntityLinkState

## Peer id of the owner, used to know who can control.
var owner_pid: int

## Global position of the entity.
var global_position: Vector2

# -- -- #

func to_dict() -> Dictionary:
	return {
		"owner_pid": owner_pid,
		"global_position": global_position
	}

func apply_dict(dict: Dictionary) -> void:
	owner_pid = dict.owner_pid
	global_position = dict.global_position

	state_changed.emit()

func init_state() -> void:
	var entity := DemoEntity.new()
	entity.link_state = self
	
	# Adds it immediately to the place where it belongs.
	NetworkBus.network_orchestrator.get_parent().add_child(entity)

extends LinkState
class_name EntityLinkState

## Peer id of the owner, used to know who can control.
var owner_pid: int

## Global position of the entity.
var global_position: Vector2

# -- -- #

func to_dict() -> Dictionary:
	return {}

func apply_dict(dict: Dictionary) -> void:
	pass

func init_state() -> DemoEntity:
	var entity := DemoEntity.new()
	entity.link_state = self

	return entity

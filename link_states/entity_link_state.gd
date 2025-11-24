extends LinkState
class_name EntityLinkState

## Peer id of the owner, used to know who can control.
var owner_pid: int

## Global position of the entity.
var global_position: Vector2

# -- Input -- #

## Move in a certain direction
func move(direction: Vector2) -> void:
	var input: Dictionary = { "direction": direction }
	input_tracker.add_input(input)

func apply_input(input: Dictionary) -> void:
	# TODO: Check here whether the input is valid
	global_position += input.direction

	# Update the input id and emit an external state change.
	last_input_id = input.input_id
	external_state_change.emit(self)

# -- -- #

func to_dict() -> Dictionary:
	return {
		"owner_pid": owner_pid,
		"global_position": global_position
	}

func apply_dict(dict: Dictionary) -> void:
	owner_pid = dict.owner_pid

	input_tracker.acknowledge_input(dict.ack_input_id)

	# TODO: Implement Server Reconciliation (simulate all non acknowledged inputs).
	var pos: Vector2 = dict.global_position
	global_position = pos

	external_state_change.emit(self)

func init_state() -> void:
	var entity := DemoEntity.new()
	entity.link_state = self
	
	# Adds it immediately to the place where it belongs.
	NetworkBus.network_orchestrator.get_parent().add_child(entity)

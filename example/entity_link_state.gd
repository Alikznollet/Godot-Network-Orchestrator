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
	global_position = dict.global_position

	external_state_change.emit(self)

func get_update() -> Dictionary:
	var pos: Vector2 = global_position

	for input in input_tracker.inputs:
		pos += input.direction

	return {
		"position": pos
	}

## Initializes the wrapper for this LinkedState, in this case the DemoEntity Node.
func init_wrapper() -> DemoEntity:
	var entity := DemoEntity.new()
	entity.link_state = self
	return entity

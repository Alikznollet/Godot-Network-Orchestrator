extends LinkedState
class_name EntityLinkedState

## Peer id of the owner, used to know who can control.
var owner_pid: int

## Global position of the entity.
var global_position: Vector2

# -- Input -- #

## Move in a certain direction
func move(direction: Vector2) -> void:
	var input: Dictionary = { "direction": direction }
	input_buffer.add_input(input)

## Apply an input dictionary to the LinkedState.
func apply_input(input: Dictionary) -> void:
	global_position += input.direction

	external_state_change.emit(self)

# -- -- #

## Turn the State into a dictionary that can be passed through the peers.
func to_dict() -> Dictionary:
	return {
		"owner_pid": owner_pid,
		"global_position": global_position
	}

## Apply a dictionary provided by to_dict()
func apply_dict(dict: Dictionary) -> void:
	owner_pid = dict.owner_pid

	input_buffer.acknowledge_input(dict.ack_input_id)
	global_position = dict.global_position

	external_state_change.emit(self)

## Get an updated version of the LinkedState as a dictionary.
func get_update() -> Dictionary:
	var pos: Vector2 = global_position

	for input in input_buffer.inputs:
		pos += input.direction

	return {
		"position": pos
	}

## Initializes the wrapper for this LinkedState, in this case the ExampleEntity Node.
func init_wrapper() -> ExampleEntity:
	var entity := ExampleEntity.new()
	entity.linked_state = self
	return entity

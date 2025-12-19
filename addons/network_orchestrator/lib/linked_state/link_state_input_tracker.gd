extends Resource
class_name LinkStateInputTracker
## Keeps track of inputs on a LinkedState.
##
## Inputs can be acknowledged by the authority and are then thrown away.

# -- Signals -- #

signal new_input()

# -- Initialization -- #

## The maximum number of tracked inputs.
var max_tracked: int

func _init(i_max_tracked: int) -> void:
	max_tracked = i_max_tracked

# -- Inputs -- #

## The track_id of the element at position 0 in the inputs array.
var input_id_base: int = 0

## Array of inputs, acts as a moving window over the track_ids.
var inputs: Array[Dictionary] = []

## Adds an input to the tracked inputs.
## If the buffer is not yet overflowing will just add it at the end.
## If the buffer starts overflowing increments input_id_base with one and throws away the first added value.
func add_input(input: Dictionary) -> void:
	if len(inputs) >= max_tracked:
		input_id_base += 1
		inputs.pop_front()
	
	var buf_id: int = len(inputs)
	var input_id: int = input_id_base + buf_id
	input["input_id"] = input_id

	inputs.push_back(input)
	new_input.emit()

## Will return the latest performed input.
func get_latest_input() -> Dictionary:
	return inputs.back()

## Acknowledges inputs up to track_id.
## Then returns all non-acknowledged inputs.
func acknowledge_input(track_id: int) -> void:
	var diff: int = track_id - input_id_base

	# Diff smaller than 0 means no inputs were acknowledged by the server that are in the buffer.
	if diff < 0: return

	# Slice is exclusive so we add one. We cut off the acknowledged part.
	inputs = inputs.slice(diff+1, len(inputs))
	input_id_base = track_id + 1





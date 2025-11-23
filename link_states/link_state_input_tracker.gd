extends Resource
class_name LinkStateInputTracker
## Keeps track of inputs on a LinkState

# -- Signals -- #

signal new_input()

# -- Initialization -- #

## The maximum number of tracked inputs.
var max_tracked: int

func _init(i_max_tracked: int) -> void:
	max_tracked = i_max_tracked

# -- Inputs -- #

## The track_id of the element at position 0 in the inputs array.
var track_id_at_zero: int = 0

## Array of inputs, acts as a moving window over the track_ids.
var inputs: Array[Dictionary] = []

## Adds an input to the tracked inputs.
## If the buffer is not yet overflowing will just add it at the end.
## If the buffer starts overflowing increments track_id_at_zero with one and throws away the first added value.
func add_input(input: Dictionary) -> void:
	if len(inputs) >= max_tracked:
		track_id_at_zero += 1
		inputs.pop_front()
	
	inputs.push_back(input)
	new_input.emit()

## Will return the latest input together with it's tracking id.
func get_latest_input() -> Dictionary:
	var buf_id: int = len(inputs)-1
	var input: Dictionary = inputs[buf_id]
	var track_id: int = track_id_at_zero + buf_id

	input["track_id"] = track_id

	return input

## Acknowledges inputs up to track_id.
## Then returns all non-acknowledged inputs.
func acknowledge_input(track_id: int) -> Array[Dictionary]:
	var diff: int = track_id - track_id_at_zero

	# Diff smaller than 0 means no inputs were acknowledged by the server that are in the buffer.
	if diff < 0: return []

	# Slice is exclusive so we add one. We cut off the acknowledged part.
	inputs = inputs.slice(0, diff+1)

	# Then simulate all the inputs that were not 
	return inputs





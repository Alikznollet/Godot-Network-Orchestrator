extends LinkedState
class_name CounterLinkedState

# -- Count -- #

var count: int = 0

## Sends an input to increment the counter.
func increment_counter_input() -> void:
	input_buffer.add_input(
		LinkedFunctionData.new(
			increment_counter.get_method(),
			[]
		)
	)

## Actually increments the counter based on the input. This is where validation would occur.
func increment_counter() -> void:
	count += 1
	external_state_change.emit(
		self,
		# This then directly forces the value to update again on the client.
		LinkedSetData.new(
			"count",
			count
		)
	)

# -- Misc -- #

func get_update() -> Dictionary:
	return {
		"count": count
	}

func init_wrapper() -> Variant:
	var counter := Counter.new()
	counter.linked_state = self
	return counter

extends LinkedState
class_name CounterLinkedState

var count: int = 0

func increment_no_event() -> void:
	input_buffer.add_input({
		"count": count + 1
	})

func increment_event() -> void:
	var event := LinkedEvent.new(
		id,
		{ "count": count + 1 }
	)
	apply_event(event)

func apply_input(input: Dictionary) -> void:
	count = input.count

	external_state_change.emit(self)

func to_dict() -> Dictionary:
	return {
		"count": count
	}

func apply_dict(dict: Dictionary) -> void:
	count = dict.count

	external_state_change.emit(self)

func get_update() -> Dictionary:
	return {
		"count": count
	}

func init_wrapper() -> Variant:
	var counter := Counter.new()
	counter.linked_state = self
	return counter

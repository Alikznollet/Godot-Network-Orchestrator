extends Label
class_name Counter

var linked_state: CounterLinkedState

func _ready() -> void:
	linked_state.update.connect(_update)

func _update():
	text = str(linked_state.count)

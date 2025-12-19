extends Sprite2D
class_name ExampleEntity
## Moveable entity used for network architecture testing.

var linked_state: EntityLinkedState = EntityLinkedState.new()

func _ready() -> void:
	var t := GradientTexture2D.new()
	texture = t
	linked_state.update.connect(update)
	linked_state.unlinked.connect(_destroy)

## Called when the update signal from LinkedState is emitted.
func update() -> void:
	var upd: Dictionary = linked_state.get_update()
	global_position = upd.position

## Emitted when the state is unlinked, this means the wrapper was destroyed.
signal destroyed(node: ExampleEntity)

## Called when the LinkedState is unlinked.
func _destroy() -> void:
	destroyed.emit(self)
	queue_free()

func _physics_process(delta: float) -> void:
	var vector: Vector2 = Input.get_vector("left", "right", "up", "down")

	if vector.length() != 0 and linked_state.owner_pid == multiplayer.get_unique_id():
		linked_state.move(vector * 100 * delta)

extends Sprite2D
class_name DemoEntity
## Moveable entity used for network architecture testing.

var link_state: EntityLinkState = EntityLinkState.new()

func _ready() -> void:
	var t := GradientTexture2D.new()
	texture = t
	link_state.update.connect(update)
	link_state.unlinked.connect(_destroy)

func update() -> void:
	var upd: Dictionary = link_state.get_update()
	global_position = upd.position

signal destroyed(node: DemoEntity)

## Called when the LinkState is unlinked.
func _destroy() -> void:
	destroyed.emit(self)
	queue_free()

func _physics_process(delta: float) -> void:
	var vector: Vector2 = Input.get_vector("left", "right", "up", "down")

	if vector.length() != 0 and link_state.owner_pid == multiplayer.get_unique_id():
		link_state.move(vector * 100 * delta)

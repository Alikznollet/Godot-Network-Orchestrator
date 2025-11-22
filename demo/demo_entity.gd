extends Sprite2D
class_name DemoEntity
## Moveable entity used for network architecture testing.

var link_state: EntityLinkState = EntityLinkState.new()

func _ready() -> void:
	var t := GradientTexture2D.new()
	texture = t

	link_state.owner_pid = multiplayer.get_unique_id()
	link_state.global_position = global_position

	link_state.state_changed.connect(update)

func update() -> void:
	global_position = link_state.global_position

func _process(delta: float) -> void:
	var vector: Vector2 = Input.get_vector("left", "right", "up", "down")

	if vector.length() != 0 and link_state.owner_pid == multiplayer.get_unique_id():
		link_state.global_position += vector * 100 * delta

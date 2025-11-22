extends Sprite2D
class_name DemoEntity
## Moveable entity used for network architecture testing.

var entity_id: int

func _ready() -> void:
	var t := GradientTexture2D.new()
	texture = t

	entity_id = multiplayer.get_unique_id()
	NetworkBus.network_orchestrator.game_state.set_entities([self])

func _process(delta: float) -> void:
	var vector: Vector2 = Input.get_vector("left", "right", "up", "down")

	if vector.length() != 0 and entity_id == multiplayer.get_unique_id():
		global_position += vector * 100 * delta
		NetworkBus.network_orchestrator.game_state.set_entities([self])

func network_metadata() -> Dictionary:
	return {
		"entity_id": entity_id,
		"position": global_position
	}

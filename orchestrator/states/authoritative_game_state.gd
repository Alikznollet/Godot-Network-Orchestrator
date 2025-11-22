extends GameState
class_name AuthoritativeGameState
## Server/Authority view of the game.

func _set_title(new_title: String):
	_title = new_title

func set_title(new_title: String):
	_title = new_title

func _set_entities(new_entities: Array):
	# For now this lacks any and all checks.
	var idx: int = -1
	for i in range(len(_entities)):
		var ent: DemoEntity = _entities[i]
		if ent.entity_id == new_entities[0].entity_id:
			idx = i
			break

	var entity: DemoEntity
	if idx > 0:
		entity = _entities[idx]
		entity.global_position = new_entities[0].position
	else:
		entity = DemoEntity.new()
		NetworkBus.network_orchestrator.get_parent().add_child(entity)
		entity.entity_id = new_entities[0].entity_id
		entity.global_position = new_entities[0].position
		_entities.append(entity)

	# Check whether there is already an update for the entities array.
	if state_update.has(entities):
		state_update.entities.append(entity.network_metadata())
	else:
		state_update["entities"] = [entity.network_metadata()]
		
func set_entities(new_entities: Array):
	if _entities.find(new_entities[0]) < 0:
		_entities.append(new_entities[0])

	var entity_metadata: Dictionary = new_entities[0].network_metadata()
	state_update["entities"] = [entity_metadata]

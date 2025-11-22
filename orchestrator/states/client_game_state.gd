extends GameState
class_name ClientGameState
## Client View of the game.

func _set_title(new_title: String):
	_title = new_title

func set_title(new_title: String):
	_title = new_title

func _set_entities(new_entities: Array):
	# Hier komt de lijst van entities toe in de user.

	for entity_meta in new_entities:
		var idx: int = -1
		for i in range(len(_entities)):
			var ent: DemoEntity = _entities[i]
			if ent.entity_id == entity_meta.entity_id:
				idx = i
				break

		var entity: DemoEntity
		if idx > 0:
			entity = _entities[idx]
			entity.global_position = entity_meta.position
		else:
			entity = DemoEntity.new()
			NetworkBus.network_orchestrator.get_parent().add_child(entity)
			entity.entity_id = entity_meta.entity_id
			entity.global_position = entity_meta.position
			_entities.append(entity)

	# Here no state update is done because we are just listening to what the authority is telling us.

func set_entities(new_entities):
	# When setting locally we just want to let the state know that a change happened.
	# If the entity is not in the list yet we do want to add it.
	if _entities.find(new_entities[0]) < 0:
		_entities.append(new_entities[0])

	var entity_metadata: Dictionary = new_entities[0].network_metadata()
	state_update["entities"] = [entity_metadata]
	state_updated.emit()

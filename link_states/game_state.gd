extends Resource
class_name GameState
## Keeps track of the global state of the game.
##
## Contains a dictionary of id -> LinkState.
## These state objects all have a to_dict() and apply_dict().

## ID -> LinkState dictionary. Holds all possible update-able states.
var link_states: Dictionary[int, LinkState] = {}

## Applies a LinkState to the correctly mapped one in link_states.
func apply_dict(dict: Dictionary) -> void:
	# Check whether the dictionary has the required fields.
	assert(dict.has("id"), "GameState: LinkState dictionary does not have 'id' field.")
	assert(dict.has("type"), "GameState: LinkState dictionary does not have 'type' field.")

	# If the id already has a LinkState
	if link_states.has(dict.id):
		var ls: LinkState = link_states[dict.id]
		ls.apply_dict(dict)
	else:
		var ls: LinkState = ClassDB.instantiate(dict.type)
		ls.apply_dict(dict)

		# TODO: Get the object from here if it is linked with one.

## Get all LinkState dictionaries as an array.
func get_all_dicts() -> Array[Dictionary]:
	var dicts: Array[Dictionary] = []

	for id in link_states:
		var dict := get_dict_from_id(id)
		dicts.append(dict)
	
	return dicts

## Get the LinkState dictionary from a specific id.
func get_dict_from_id(id: int) -> Dictionary:
	if not link_states.has(id): print("GameState: Could not find dict with id."); return {};

	var ls: LinkState = link_states[id]
	var dict := ls.to_dict()

	dict["id"] = id
	dict["type"] = ls.get_script().get_global_name()

	return dict

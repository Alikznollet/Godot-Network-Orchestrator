extends Resource
class_name GameState
## Keeps track of the global state of the game.
##
## Contains a dictionary of id -> LinkState.
## These state objects all have a to_dict() and apply_dict().

## ID -> LinkState dictionary. Holds all possible update-able states.
var link_states: Dictionary[int, LinkState] = {}

## Will forcible add a state to the state dict.
func force_add_state(state: LinkState) -> void:
	# Generate a random id until it is not present.
	var id := randi()
	while link_states.has(id): id = randi()

	link_states[id] = state
	state.init_state()

## Will apply a list of dictionaries of LinkStates.
func apply_dicts(dicts: Array[Dictionary]) -> void:
	for dict in dicts:
		apply_dict(dict)

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
		ls.init_state()
		link_states[dict.id] = ls

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

# -- Updates -- #

## Array of updated LinkState ids.
var updates: Array[int] = []

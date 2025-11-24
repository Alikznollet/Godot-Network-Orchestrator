@abstract
extends Resource
class_name GameState
## Keeps track of the global state of the game.
##
## Contains a dictionary of id -> LinkState.
## These state objects all have a to_dict() and apply_dict().

## ID -> LinkState dictionary. Holds all possible update-able states.
var link_states: Dictionary[int, LinkState] = {}

# -- Adding & Applying -- #

## Adds a LinkState to the state dictionary.
## This is to only be called from the authority.
func add_state(ls: LinkState) -> void:
	if NetworkBus.multiplayer.get_unique_id() != 1: print("GameState: Cannot add LinkState when not the authority."); return

	# Generate a random id until it is not present.
	var id := randi()
	while link_states.has(id): id = randi()

	link_states[id] = ls
	ls.id = id
	ls.init_state()
	ls.local_state_change.connect(local_change)
	ls.external_state_change.connect(external_change)

	add_update(id, ls.to_dict())

## Will apply a list of dictionaries of LinkStates.
func apply_dicts(dicts: Array[Dictionary]) -> void:
	for dict in dicts:
		apply_dict(dict)

## Applies a LinkState to the correctly mapped one in link_states.
func apply_dict(dict: Dictionary) -> void:
	# Check whether the dictionary has the required fields.
	assert(dict.has("state_id"), "GameState: LinkState dictionary does not have 'id' field.")
	assert(dict.has("type"), "GameState: LinkState dictionary does not have 'type' field.")

	# If the id already has a LinkState
	if link_states.has(dict.state_id):
		var ls: LinkState = link_states[dict.state_id]
		ls.apply_dict(dict)
	else:
		assert(LinkState.STATES.has(dict.type), "GameState: LinkState.STATES does not have an entry for %s." % dict.type)
		var ls: LinkState = LinkState.STATES[dict.type].new()
		ls.id = dict.state_id
		ls.apply_dict(dict)
		ls.init_state()
		link_states[dict.state_id] = ls
		ls.local_state_change.connect(local_change)
		ls.external_state_change.connect(external_change)
	
# -- Getting Dictionaries -- #

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

# -- Updates & Changes -- #

@abstract
## Reacts to a local change of any LinkState.
func local_change(ls: LinkState) -> void

@abstract
## Reacts to a change from outside. Client -> Authority or other way around.
func external_change(ls: LinkState) -> void

## Returns an array of updates with their ids inserted into the update dictionary.
func get_updated_dicts() -> Array[Dictionary]:
	var dicts: Array[Dictionary] = []
	for state_id in updates:
		var dict: Dictionary = updates[state_id]
		var ls: LinkState = link_states[state_id]
		dict["state_id"] = state_id 
		dict["type"] = ls.get_script().get_global_name()
		dict["ack_input_id"] = ls.last_input_id
		dicts.append(dict)

	updates.clear()
	return dicts

## Adds an update linked to a state_id to the updates dictionary.
## This overwrites whatever was there before.
func add_update(state_id: int, update: Dictionary) -> void:
	updates[state_id] = update

## Applies an array of inputs.
func apply_inputs(inputs: Array[Dictionary]) -> void:
	for input in inputs:
		apply_input(input)

## Applies a single input to the corresponding LinkState.
func apply_input(input: Dictionary) -> void:
	var state_id: int = input.state_id
	var ls: LinkState = link_states[state_id]
	ls.apply_input(input)

## Array of updated LinkState ids.
var updates: Dictionary[int, Dictionary] = {}

@abstract
extends Resource
class_name GameState
## Keeps track of the global state of the game.
##
## Holds the States that are supposed to be linked between users.
## Available functions include adding states (authority only recommended), applying changes
## and registering updates.

## ID -> LinkedState dictionary. Holds all possible update-able states.
var linked_states: Dictionary[int, LinkedState] = {}

# -- Adding States -- #

## Emitted when a LinkedState is initialized with a Node.
signal state_linked(wrapper: Variant)

## Adds a LinkedState to the state dictionary.
## This is to only be called from the authority. Though not enforced in here.
## Optionally returns a node if one is linked to the state, otherwise just null.
func link_state(ls: LinkedState) -> void:
	# Generate a random id until it is not present.
	var id := randi()
	while linked_states.has(id): id = randi()

	# Link up the LinkedState and then add it as an update.
	linked_states[id] = ls
	ls.id = id
	ls.local_state_change.connect(local_change)
	ls.external_state_change.connect(external_change)
	ls.event_state_change.connect(event_change)

	# Return the node linked to the state if there is one.
	var wrapper: Variant = ls.init_wrapper()
	state_linked.emit(wrapper)

	ls.external_state_change.emit(ls, LinkedDummyData.new())

## Will unlink a certain state from the GameState.
## Sends this to all clients so they can unlink it too.
## Can only be called from the authority.
func unlink_state(ls: LinkedState) -> void:
	linked_states.erase(ls.id)
	ls.unlink()

	add_update(ls.id, LinkedDummyData.new(), true)

# -- Applying Dicts and Inputs -- #

## Will apply a list of dictionaries of LinkStates.
func apply_dicts(dicts: Array[Dictionary]) -> void:
	for dict in dicts:
		apply_dict(dict)

## Applies a LinkedState to the correctly mapped one in linked_states.
func apply_dict(dict: Dictionary) -> void:
	assert(dict.has("link_id"), "GameState: LinkedState dictionary does not have 'link_id' field.")

	# Check whether the state has to be unlinked.
	if dict.has("unlinked"):
		if linked_states.has(dict.link_id):
			var ls: LinkedState = linked_states[dict.link_id]
			linked_states.erase(ls.id)
			ls.unlink()
		return

	# Check whether the dictionary has the required fields.
	assert(dict.has("link_type"), "GameState: LinkedState dictionary does not have 'link_type' field.")

	# If the id already has a LinkedState
	if linked_states.has(dict.link_id):
		var ls: LinkedState = linked_states[dict.link_id]
		ls.apply_dict(dict)
	else:
		var ls: LinkedState = LinkedStateRegistry.get_script_from_id(dict["link_type"]).new()
		ls.id = dict.link_id
		ls.apply_dict(dict)
		linked_states[dict.link_id] = ls
		ls.local_state_change.connect(local_change)
		ls.external_state_change.connect(external_change)
		ls.event_state_change.connect(event_change)

		# Get the node if there is one.
		var wrapper: Variant = ls.init_wrapper()
		state_linked.emit(wrapper)

## Applies an array of inputs.
func apply_inputs(inputs: Array[Dictionary]) -> void:
	for input in inputs:
		apply_input(input)

## Applies a single input to the corresponding LinkedState.
## Also updates the last_input_id field of the LinkedState.
func apply_input(input: Dictionary) -> void:
	var link_id: int = input.link_id
	var ls: LinkedState = linked_states[link_id]
	ls.last_input_id = input.input_id
	ls.apply_input(input)
	
# -- Getting Dictionaries -- #

## Get all LinkedState dictionaries as an array.
func get_all_dicts() -> Array[Dictionary]:
	var dicts: Array[Dictionary] = []

	for id in linked_states:
		var dict := get_dict_from_id(id)
		dicts.append(dict)
	
	return dicts

## Get the LinkedState dictionary from a specific id.
func get_dict_from_id(id: int) -> Dictionary:
	if not linked_states.has(id): print("GameState: Could not find dict with id."); return {};

	var ls: LinkedState = linked_states[id]
	var dict := {}

	dict["link_id"] = id
	dict["link_type"] = LinkedStateRegistry.get_id(ls.get_script())
	dict["ack_input_id"] = ls.last_input_id

	return dict

# -- Updates & Changes -- #

@abstract
## Reacts to a local change of any LinkedState.
func local_change(ls: LinkedState) -> void

@abstract
## Reacts to a change from outside. Client -> Authority or other way around.
func external_change(ls: LinkedState, ld: LinkedData) -> void

## Returns an array of updates with their ids inserted into the update dictionary.
func get_updates_as_dicts() -> Array[Dictionary]:
	var dicts: Array[Dictionary] = []
	for link_id in updates:
		var upd: LinkedUpdate = updates[link_id] 

		# This means the state is still linked.
		if not upd.unlinked: 
			var ls: LinkedState = linked_states[link_id]
			upd.link_type = LinkedStateRegistry.get_id(ls.get_script())
			upd.ack_input_id = ls.last_input_id
		
		dicts.append(upd.to_dictionary())

	updates.clear()
	return dicts

## Adds an update linked to a link_id to the updates dictionary.
## This overwrites whatever was there before.
func add_update(link_id: int, data: LinkedData, unlinked: bool = false) -> void:
	var upd: LinkedUpdate = updates.get_or_add(
		link_id,
		LinkedUpdate.new(
			link_id
		)
	)
	upd.add_data(data)

## Apply all of the incoming LinkedUpdate objects.
func apply_updates(update_dicts: Array[Dictionary]) -> void:
	for update_dict in update_dicts:
		var update: LinkedUpdate = LinkedUpdate.from_dictionary(update_dict)
		var ls: LinkedState = linked_states.get(update.link_id)
		update.apply_update(ls)

## Will tell the connected function to send all the current updates.
@warning_ignore("unused_signal")
signal send_updates()

## Array of updated LinkedState ids.
var updates: Dictionary[int, LinkedUpdate] = {}

# -- Events -- #

@abstract
## Linked up to the state change by event.
func event_change(ls: LinkedState, event: LinkedEvent) -> void

## Signals the orchestrator an event has to be sent.
signal send_event(event: Dictionary)

## Listens to each LinkedState for events.
func _new_event(event: LinkedEvent) -> void:
	send_event.emit(event.to_dictionary())

## Apply an event to the correct LinkedState.
func apply_event(event: LinkedEvent) -> void:
	var ls: LinkedState = linked_states.get(event.link_id)

	if ls:
		ls.apply_event(event)

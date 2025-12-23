@tool
extends NetworkOrchestrator
class_name ClientNetworkOrchestrator
## A client in the network
##
## Receives the authoritative state from the authority and has to apply this to the client state.
## When a change happens in the client state sends this change to the authority.

# -- Debug -- #

## How much delay to add to each state update before it is sent and received.
## This is only meant to be used in testing scenarios to emulate lag.
## Only executed if game is running in a debug build.
@export var artificial_lag: float

# -- Initialization -- #

func _init() -> void:
	game_state = ClientGameState.new()

# -- Sending & Receiving -- #

## Send the client state to the authority.
func send_state() -> void:
	var update: Array[Dictionary] =  game_state.get_updates_as_dicts()

	if not update.is_empty():
		if OS.is_debug_build(): await get_tree().create_timer(artificial_lag/1000).timeout
		receive_state.rpc_id(1, update)

## Receive an authoritative state and apply it to the client state.
func receive_state(updates: Array[Dictionary]) -> void:
	if OS.is_debug_build(): await get_tree().create_timer(artificial_lag/1000).timeout

	game_state.apply_updates(updates)

## Send all states to the client that asked for it.
func sync_state(states: Array) -> void:
	game_state.apply_dicts(states)

## Request a game sync from the host.
func request_game_sync() -> void:
	sync_state.rpc_id(1, [{"id": multiplayer.get_unique_id()}])

## Receives an event from the authority.
func send_event(event: Dictionary) -> void:
	game_state.apply_event(LinkedEvent.from_dictionary(event))

@tool
@abstract
extends Node
class_name NetworkOrchestrator
## Abstract interface defining a couple of important networking functions.

## The current (authoritative/client) state of the game, depending on the type of Orchestrator.
var game_state: GameState:
	set(new_game_state):
		game_state = new_game_state
		if game_state: 
			game_state.send_updates.connect(send_state)
			game_state.state_linked.connect(_state_linked)
			game_state.send_event.connect(send_event)

# -- Node adding -- #

## Signal that notifies the outside that a NetworkState was added. 
## A wrapper is provided to be tested by the developer.
signal state_linked(wrapper: Variant)

## Emits the state_linked signal with the wrapper passed through.
func _state_linked(wrapper: Variant) -> void:
	state_linked.emit(wrapper)

@abstract
func send_state() -> void

@rpc("any_peer", "call_remote", "unreliable")
@abstract
func receive_state(updates: Array[Dictionary]) -> void

@rpc("any_peer", "call_remote", "reliable")
@abstract
func sync_state(states: Array) -> void

@rpc("authority", "call_remote", "reliable")
@abstract
func send_event(event: Dictionary) -> void

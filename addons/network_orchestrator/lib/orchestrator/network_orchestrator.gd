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
			game_state.node_added.connect(_add_node)

## Adds a node to the parent of the orchestrator. Triggered by the node_added signal in GameState.
## If the node needs to easily be retrieved again groups could be nice.
func _add_node(node: Node) -> void:
	get_parent().add_child(node)

@abstract
func send_state() -> void

@rpc("any_peer", "call_remote", "unreliable")
@abstract
func receive_state(updates: Array[Dictionary]) -> void

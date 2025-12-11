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

# -- Node adding -- #

## Signal that notifies the outside a node was added via LinkState. 
## This node can be tested for what it is with the 'is' keyword.
signal node_added(node: Node)

## Emits the node_added signal to emit the node itself.
func _add_node(node: Node) -> void:
	node_added.emit(node)

@abstract
func send_state() -> void

@rpc("any_peer", "call_remote", "unreliable")
@abstract
func receive_state(updates: Array[Dictionary]) -> void

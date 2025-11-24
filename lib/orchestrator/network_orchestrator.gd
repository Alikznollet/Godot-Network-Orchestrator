@abstract
extends Node
class_name NetworkOrchestrator
## Abstract interface defining a couple of important networking functions.

func _init() -> void:
	NetworkBus.network_orchestrator = self

## Multiplayer peer used to rpc the other peers.
var peer: ENetMultiplayerPeer

## The current (authoritative/client) state of the game, depending on the type of Orchestrator.
var game_state: GameState

@abstract
func send_state() -> void

@rpc("any_peer")
@abstract
func receive_state(updates: Array[Dictionary]) -> void

@abstract
extends Node
class_name NetworkOrchestrator
## Abstract interface defining a couple of important networking functions.

func _init() -> void:
	NetworkBus.network_orchestrator = self

# -- Settings -- #

@export var enable_prediction: bool

@export var enable_reconciliation: bool

@export var enable_interpolation: bool

@export var enable_lag_compensation: bool

## Multiplayer peer used to rpc the other peers.
var peer: ENetMultiplayerPeer

## The current (authoritative/client) state of the game, depending on the type of Orchestrator.
var game_state: GameState = GameState.new()

@abstract
func send_state() -> void

@rpc("any_peer")
@abstract
func receive_state(updates: Array[Dictionary]) -> void

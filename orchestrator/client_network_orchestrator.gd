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

func _ready() -> void:
	# Supposed to be replaced with SteamMultiplayerPeer in a real setting.
	peer = ENetMultiplayerPeer.new()

	# In a real setting this error should be handled gracefully.
	var status := peer.create_client("127.0.0.1", 9999)
	assert(status == OK, "ClientNetworkOrchestrator: Could not connect to local server. Status: %d" % status)

	multiplayer.multiplayer_peer = peer
	
	# Create a local state
	game_state = ClientGameState.new()
	game_state.state_updated.connect(send_state) # Send updated state each time something changes.

## Send the client state to the authority.
func send_state() -> void:
	if OS.is_debug_build(): await get_tree().create_timer(artificial_lag).timeout

	var update: Dictionary = game_state.state_update
	game_state.state_update = {}

	if not update.is_empty():
		receive_state.rpc_id(1, update)
		print("Send Client:")
		print(update)

## Receive an authoritative state and apply it to the client state.
func receive_state(state_update: Dictionary) -> void:
	if OS.is_debug_build(): await get_tree().create_timer(artificial_lag).timeout

	game_state.apply_state_update(state_update)
	print("Receive Client:")
	print(state_update)

extends NetworkOrchestrator
class_name ClientNetworkOrchestrator
## A client in the network
##
## Receives the authoritative state from the authority and has to apply this to the client state.
## When a change happens in the client state sends this change to the authority.

func _ready() -> void:
	# Supposed to be replaced with SteamMultiplayerPeer in a real setting.
	peer = ENetMultiplayerPeer.new()

	# In a real setting this error should be handled gracefully.
	var status := peer.create_client("127.0.0.1", 9999)
	assert(status == OK, "ClientNetworkOrchestrator: Could not connect to local server. Status: %d" % status)

	multiplayer.multiplayer_peer = peer

## Send the client state to the authority.
func send_state() -> void:
	pass

## Receive an authoritative state and apply it to the client state.
func receive_state(state: String) -> void:
	print("Client:")
	print(state)

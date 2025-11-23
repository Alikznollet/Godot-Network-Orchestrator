extends NetworkOrchestrator
class_name AuthoritativeNetworkOrchestrator
## The Authority in the network
##
## Holds the authoritative state and distributes it on an interval to the other clients.
## Receives client states from other peers and applies them to the authoritative state, only if they make sense.

# -- Settings -- #

## Frequency of updates sent to other clients.
## This is a target, so if the host cannot reach this it could be less than indicated.
## An example would be if the host is lagging for any reason whatsoever.
@export_range(1, 1000) var target_update_frequency: int:
	set(new_frequency):
		target_update_frequency = new_frequency
		if update_timer: # If a timer is present we update it's frequency.
			update_timer.stop()
			update_timer.wait_time = 1./target_update_frequency
			update_timer.start()

## Timer with time being 1/target_update_frequency.
## When this timer sends a timeout the state is sent to all clients.
var update_timer: Timer

func _ready() -> void:
	# This is supposed to be replaced with SteamMultiplayerPeer when used in a game.
	# The rest roughly stays the same.
	peer = ENetMultiplayerPeer.new()

	# This status should be handled gracefully in a real setting
	var status := peer.create_server(9999)
	assert(status == OK, "AuthoritativeNetworkOrchestrator: Could not start server. Status: %d" % status)

	multiplayer.multiplayer_peer = peer

	# Set up the timer that will be used to send updates.
	update_timer = Timer.new()
	update_timer.wait_time = 1./target_update_frequency
	update_timer.timeout.connect(send_state)
	add_child(update_timer)

	update_timer.start()

	game_state = AuthoritativeGameState.new()

## Send the authoritative state to all connected peers.
func send_state() -> void:
	var update: Array[Dictionary] = game_state.get_updated_dicts()

	if not update.is_empty():
		receive_state.rpc(update)

## Receive client states from all connected peers.
## Check them for legitimacy and then apply them to the authoritative state.
func receive_state(updates: Array[Dictionary]) -> void:
	# TODO: Apply the needed checks here to check for client state correctness.
	game_state.apply_dicts(updates)

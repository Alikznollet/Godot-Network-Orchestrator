@tool
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

# -- Initialization -- #

func _init() -> void:
	game_state = AuthoritativeGameState.new()

func _ready() -> void:
	# Set up the timer that will be used to send updates.
	update_timer = Timer.new()
	update_timer.wait_time = 1./target_update_frequency
	update_timer.timeout.connect(send_state)
	add_child(update_timer)

	update_timer.start()

# -- Altering the GameState -- #

## Links a state to the current GameState.
func link_state(ls: LinkedState) -> void:
	assert(game_state, "AuthoritativeNetworkOrchestrator: No Game state found to link the LinkedState to.")
	game_state.link_state(ls)

## Unlinks a state from the current GameState.
func unlink_state(ls: LinkedState) -> void:
	assert(game_state, "AuthoritativeNetworkOrchestrator: No Game state found to link the LinkedState to.")
	game_state.unlink_state(ls)

# -- Sending & Receiving -- #

## Send the authoritative state to all connected peers.
func send_state() -> void:
	var update: Array[Dictionary] = game_state.get_updated_dicts()

	if not update.is_empty():
		receive_state.rpc(update)

## Receive client states from all connected peers.
## Check them for legitimacy and then apply them to the authoritative state.
func receive_state(inputs: Array[Dictionary]) -> void:
	game_state.apply_inputs(inputs)

## Send all states to the client that asked for it.
func sync_state(states: Array) -> void:
	var request: Dictionary = states.front()
	var dicts: Array[Dictionary] = game_state.get_all_dicts()

	sync_state.rpc_id(request.id, dicts)

@abstract
extends Resource
class_name LinkState
## State of various objects or nodes.
##
## Used to update the objects this state is connected to via signaling.
## LinkState objects or nodes that contain LinkState objects can only be created
## on the authority. This is to conserve id consistency.

## ID is stored here and in the dictionary.
var id: int

## Exclusively used for authoritative state.
var last_input_id: int = -1

func _init() -> void:
	input_tracker.new_input.connect(_new_input)

# -- Input Tracking & Processing -- #

## Listens whether a new input has been done for this LinkState.
## If so will emit the local_state_change signal.
func _new_input() -> void:
	local_state_change.emit(self)

## Applies an input dictionary.
## Only called from the authority where client inputs are the incoming packets.
@abstract
func apply_input(input: Dictionary) -> void

## Tracks the last n updates of the LinkState.
## Only holds potential queued inputs.
var input_tracker: LinkStateInputTracker = LinkStateInputTracker.new(200)

# ! Functions regarding inputs are defined in the link_states themselves.

# -- Signals -- #

@warning_ignore("unused_signal")
## Tells the device using this state to update itself.
signal update()

## Broadcasted whenever the state changes externally (from other source).
@warning_ignore("unused_signal")
signal external_state_change(ls: LinkState)

## Broadcasted whenever the state receives a proposed change.
@warning_ignore("unused_signal")
signal local_state_change(ls: LinkState)

# -- State Alteration & Updates -- #

## Will turn the LinkState into a dictionary that can be sent over the network.
@abstract
func to_dict() -> Dictionary

## Will apply the dictionary to the current state.
## ! Do not forget to send an external_state_change signal at the end.
@abstract
func apply_dict(dict: Dictionary) -> void

## Returns everything the outside needs to update themselves.
@abstract 
func get_update() -> Dictionary


## Will initialize the node linked to this state.
## When no node is linked to the state this does nothing.
func init_node() -> Node:
	return null

# -- ALL STATES -- #

static var STATES: Dictionary[StringName, GDScript] = {
	"EntityLinkState": EntityLinkState
}

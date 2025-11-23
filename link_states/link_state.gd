@abstract
extends Resource
class_name LinkState
## State of various objects
##
## Used to update the objects this state is connected to via signaling.
## LinkState objects or nodes that contain LinkState objects can only be created
## on the authority. This is to conserve id consistency.

## ID is stored here and in the dictionary.
var id: int

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

# -- Methods -- #

## Will turn the LinkState into a dictionary that can be sent over the network.
@abstract
func to_dict() -> Dictionary

## Will apply the dictionary to the current state.
## ! Do not forget to send an external_state_change signal at the end.
@abstract
func apply_dict(dict: Dictionary) -> void

## Will initialize the node linked to this state.
## When no node is linked to the state this does nothing.
func init_state() -> void:
	pass

# -- States -- #

static var STATES: Dictionary[StringName, GDScript] = {
	"EntityLinkState": EntityLinkState
}

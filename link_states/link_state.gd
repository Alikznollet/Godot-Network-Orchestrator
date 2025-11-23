@abstract
extends Resource
class_name LinkState
## State of various objects
##
## Used to update the objects this state is connected to via signaling.
## LinkState objects or nodes that contain LinkState objects can only be created
## on the authority. This is to conserve id consistency.

# -- Signals -- #

## Broadcasted whenever the state changes.
@warning_ignore("unused_signal")
signal state_changed()

## Broadcasted whenever the state receives a proposed change.
@warning_ignore("unused_signal")
signal state_changed_local()

# -- Methods -- #

## Will turn the LinkState into a dictionary that can be sent over the network.
@abstract
func to_dict() -> Dictionary

## Will apply the dictionary to the current state.
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

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

# -- Methods -- #

## Will turn the LinkState into a dictionary that can be sent over the network.
@abstract
func to_dict() -> Dictionary

## Will apply the dictionary to the current state.
@abstract
func apply_dict(dict: Dictionary) -> void

## Will return an instantiated node made from the state.
## This method is only defined on states of nodes.
func init_state() -> Variant:
	var msg := "LinkState: init_state() was called on a non Node, or not defined."
	assert(false, msg)
	return null

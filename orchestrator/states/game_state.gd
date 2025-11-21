@abstract
extends Resource
class_name GameState
## Keeps track of the global state of the game.
##
## This object helps the NetworkOrchestrator know what to send.
## It automatically alters what it's holding.
## All variables here need to have a setter.
## This setter converts from the raw variables to the actual types.
## The variable starting with _ contains the actual type.
## An example is:
## var _foo: Bar
## var foo: set(new_foo): _set_foo(new_foo)
##					get(): return _foo
##
## The private function is the function that checks the new state.
## The public function can be called from outside and will force the state.

## Title of the game. Just a dummy.
var _title: String
var title:
	set(new_title): _set_title(new_title)
	get(): return _title

@abstract 
func _set_title(new_title)
@abstract
func set_title(new_title)

# -- State Update -- #

## Consists of all recently updated variables.
## Set to an empty dictionary if read.
var state_update: Dictionary:
	get():
		var _temp = state_update
		state_update = {}
		return _temp

func apply_state_update(p_state_update: Dictionary):
	# When applying a state update we want all checks to happen.
	# This is where we call the custom setters.
	for key in p_state_update:
		var value = p_state_update[key]

		# Raw variables are just updated like normal here.
		# Arrays of variables or custom variables are converted.
		set(key, value)

@abstract
extends Resource
class_name GameState
## Keeps track of the global state of the game.
##
## This object helps the NetworkOrchestrator know what to send.
## It automatically alters what it's holding.
## All variables here need to have a setter.

## Title of the game. Just a dummy.
var _title: String
var title: String:
	set(new_title): set_title(new_title)
	get(): return _title

@abstract 
func set_title(new_title: String)

# -- State Update -- #

## Consists of all recently updated variables.
## Set to an empty dictionary if read.
var _state_update: Dictionary:
	get():
		var _temp = _state_update
		_state_update = {}
		return _temp

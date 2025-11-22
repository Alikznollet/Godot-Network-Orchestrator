extends Resource
class_name GameState
## Keeps track of the global state of the game.
##
## Contains a dictionary of id -> LinkState.
## These state objects all have a to_dict() and apply_dict().

## ID -> LinkState dictionary. Holds all possible update-able states.
var link_states: Dictionary[int, LinkState] = {}

@abstract
extends Resource
class_name LinkedState
## State of various objects or nodes.
##
## Used to update the objects this state is connected to via signaling.
## LinkedState objects or nodes that contain LinkedState objects can only be created
## on the authority. This is to conserve id consistency.

## ID is stored here and in the dictionary.
var id: int

## Exclusively used for authoritative state.
var last_input_id: int = -1

## Requires the user to pass the size of the input buffer. Uses a buffer of 200 inputs by default.
## Window size always needs to be an integer larger than 0.
func _init(input_window_size: int = 200) -> void:
	assert(input_window_size > 0, "LinkedState: Size of the input window should be an integer larger than 0.")
	
	input_buffer = LinkedStateInputBuffer.new(input_window_size)
	input_buffer.new_input.connect(_new_input)

# -- Removal -- #

## Emitted when the LinkedState is told to be unlinked.
## Further handling happens in the wrapper defined by the developer.
signal unlinked()

## Called by the GameState when the LinkedState is unlinked.
func unlink() -> void:
	unlinked.emit()

# -- Input Tracking & Processing -- #

## Listens whether a new input has been done for this LinkedState.
## If so will emit the local_state_change signal.
func _new_input() -> void:
	local_state_change.emit(self)

## Tracks the last n updates of the LinkedState.
## Only holds potential queued inputs.
var input_buffer: LinkedStateInputBuffer

# -- Signals -- #

@warning_ignore("unused_signal")
## Tells the device using this state to update itself.
signal update()

## Broadcasted whenever the state changes externally (from other source).
@warning_ignore("unused_signal")
signal external_state_change(ls: LinkedState, ld: LinkedData)

## Broadcasted whenever the state receives a proposed change.
@warning_ignore("unused_signal")
signal local_state_change(ls: LinkedState, ld: LinkedData)

# -- State Alteration & Updates -- #

## Returns everything the outside needs to update themselves.
@abstract 
func get_update() -> Dictionary

# -- Events -- #

## Emitted when something was changed about the state with an Event.
signal event_state_change(ls: LinkedState)

## Applies an event to the current LinkedState.
func apply_event(event: LinkedEvent) -> void:
	for key in event.data:
		set(key, event.data[key])

	event_state_change.emit(self, event)

# -- Wrapper -- #

## Initialize the resource that is supposed to be Linked between clients.
## Wrapper can be a Node or a Resource, whatever is needed.
@abstract
func init_wrapper() -> Variant

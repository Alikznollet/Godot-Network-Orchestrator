extends GameState
class_name AuthoritativeGameState
## Authoritative extension of GameState
##
## Due to handling of state updates being slightly different for client and authority
## they are being split up into two classes.

## A local change for the authority means the authority altered it's own state.
## We can treat this just like an external change.
func local_change(ls: LinkedState) -> void:
	# Apply any input made by the authority directly to the state.
	# Apply_input will then trigger an external_change signal.
	var ld: LinkedData = ls.input_buffer.get_latest_input()
	ld.apply(ls)
	
	# Immediately ack the input.
	ls.input_buffer.acknowledge_input(ld.input_id)

## This won't be called because on the server we will be handling inputs from clients not states.
func external_change(ls: LinkedState, ld: LinkedData) -> void:
	# Send the whole state altered back to the clients
	add_update(ls.id, ld)

	# Update the local View
	# apply_input() will choose if the input gets accepted or not.
	ls.update.emit()

## Reacts to an Event made Change Authority side. Will also send the Event to the clients.
func event_change(ls: LinkedState, event: LinkedEvent) -> void:
	send_event.emit(event.to_dictionary())
	
	ls.update.emit()

extends Resource
class_name LinkedEvent
## An Event that should be linked through the network.
## 
## Events work differently from Normal State Updates.
## Only the Authority can send an Event, and multiple Events need to be played in order.
## Events are therefore not sent via UDP, but reliably.
## It's important that the keys in 'data' have the actual variable names from the LinkedState.

## ID of the LinkState this Event has an effect on.
var link_id: int

## Dictionary of the update Data.
var data: Dictionary

func _init(id: int, event_data: Dictionary) -> void:
	link_id = id
	data = event_data

func to_dictionary() -> Dictionary:
	return {
		"link_id": link_id,
		"data": data
	}

static func from_dictionary(dict: Dictionary) -> LinkedEvent:
	var event := LinkedEvent.new(
		dict.link_id,
		dict.data
	)
	return event

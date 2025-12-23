extends Resource
class_name LinkedUpdate
## An Update that can be sent over RPC.

## ID of the link corresponding to this update.
var link_id: int

## The data this update carries.
var data: Array[LinkedData] = []

## The backend stuff this update needs to be useful.
var settings: Dictionary = {}

func apply_update(ls: LinkedState) -> void:
	for ld in data:
		ld.apply(ls)

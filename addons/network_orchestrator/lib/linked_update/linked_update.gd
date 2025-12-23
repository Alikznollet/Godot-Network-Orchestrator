extends Resource
class_name LinkedUpdate
## An Update that can be sent over RPC.

## ID of the link corresponding to this update.
var link_id: int

## Whether this State has been unlinked.
var unlinked: bool = false

## The Type of link.
var link_type: int

## ID of the input that is to be acknowledged.
var ack_input_id: int

# -- LinkedData -- #

## The data this update carries.
var data: Array[LinkedData] = []

func add_data(ld: LinkedData) -> LinkedUpdate:
	data.append(ld)
	return self

# -- Misc -- #

func _init(id: int) -> void:
	link_id = id

func apply_update(ls: LinkedState) -> void:
	for ld in data:
		ld.apply(ls)

func to_dictionary() -> Dictionary:
	var dict: Dictionary = {
		"link_id": link_id,
		"unlinked": unlinked,
		"link_type": link_type,
		"ack_input_id": ack_input_id
	}

	var data_dicts: Array[Dictionary] = []
	for ld in data:
		data_dicts.append(ld.to_dictionary())
	
	dict["data"] = data_dicts

	return dict

static func from_dictionary(dict: Dictionary) -> LinkedUpdate:
	var lu := LinkedUpdate.new(
		dict.link_id
	)
	lu.unlinked = dict.unlinked
	lu.link_type = dict.link_type
	lu.ack_input_id = dict.ack_input_id

	for ld_dict in dict.data:
		lu.add_data(LinkedData.from_dictionary(ld_dict))

	return lu

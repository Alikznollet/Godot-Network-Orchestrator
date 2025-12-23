@abstract
extends Node
class_name LinkedData
## Holds Data that was linked via a LinkedState.
##
## Carried by a LinkedUpdate this class can carry the data to another peer.

enum DATA_TYPE {
	FUNCTION,
	GET,
	SET
}

@abstract
## Applies whatever the data object is meant to do to the applicable object.
func apply(applicable: Variant) -> void

@abstract
## Creates a dictionary from a LinkedData object.
func to_dictionary() -> Dictionary

## Returns a new LinkedData object from a dictionary.
static func from_dictionary(dict: Dictionary) -> LinkedData:
	var ld: LinkedData

	match dict.ld_type:
		DATA_TYPE.FUNCTION:
			ld = LinkedFunctionData.new()
			ld.function_name = dict.fn
			ld.arguments = dict.args
		DATA_TYPE.GET:
			ld = LinkedGetData.new()
			ld.key = dict.key
			ld.next = LinkedData.from_dictionary(dict.next)
		DATA_TYPE.SET:
			ld = LinkedSetData.new()
			ld.key = dict.key
			ld.value = dict.val

	return ld

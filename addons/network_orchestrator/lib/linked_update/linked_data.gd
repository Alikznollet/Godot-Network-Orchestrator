@abstract
extends Resource
class_name LinkedData
## Holds Data that was linked via a LinkedState.
##
## Carried by a LinkedUpdate this class can carry the data to another peer.

## The Input ID of this LinkedData. -1 If not an Input.
var input_id: int = -1

enum DATA_TYPE {
	FUNCTION,
	GET,
	SET,
	DUMMY
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
			ld = LinkedFunctionData.new(
				dict.fn,
				dict.args
			)
		DATA_TYPE.GET:
			ld = LinkedGetData.new(
				dict.key,
				LinkedData.from_dictionary(dict.next)
			)
		DATA_TYPE.SET:
			ld = LinkedSetData.new(
				dict.key,
				dict.val
			)
		DATA_TYPE.DUMMY:
			ld = LinkedDummyData.new()

	return ld

# -- Fast Creation -- #

static func GET_FUNC(key: String, func_name: String, arguments: Array) -> LinkedData:
	return LinkedGetData.new(
		key,
		LinkedFunctionData.new(
			func_name,
			arguments
		)
	)

static func GET_SET(key: String, key_2: String, value: Variant) -> LinkedData:
	return LinkedGetData.new(
		key,
		LinkedSetData.new(
			key_2,
			value
		)
	)

extends LinkedData
class_name LinkedFunctionData

# TODO: Make sure some functions are blacklisted.

## Name of the function to be called.
var function_name: String

## The function arguments to be passed to the function.
## ! Arguments need to be standard types.
var arguments: Array

func _init(func_name: String, args: Array) -> void:
	function_name = func_name
	arguments = args

func apply(applicable: Variant) -> void:
	applicable.callv(function_name, arguments)

func to_dictionary() -> Dictionary:
	return {
		"ld_type": DATA_TYPE.FUNCTION,
		"fn": function_name,
		"args": arguments
	}

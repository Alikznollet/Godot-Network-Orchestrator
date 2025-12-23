extends LinkedData
class_name LinkedFunctionData

## Name of the function to be called.
var function_name: String

## The function arguments to be passed to the function.
## ! Arguments need to be standard types.
var arguments: Array

func apply(applicable: Variant) -> void:
	applicable.callv(function_name, arguments)

func to_dictionary() -> Dictionary:
	return {
		"ld_type": DATA_TYPE.FUNCTION,
		"fn": function_name,
		"args": arguments
	}

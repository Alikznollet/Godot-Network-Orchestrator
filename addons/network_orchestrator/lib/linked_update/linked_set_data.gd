extends LinkedData
class_name LinkedSetData

## Name of the property we want to change.
var key: String

## The value we want to set the property to.
var value: Variant

func apply(applicable: Variant) -> void:
	applicable.set(key, value)

func to_dictionary() -> Dictionary:
	return {
		"ld_type": DATA_TYPE.SET,
		"key": key,
		"val": value
	}

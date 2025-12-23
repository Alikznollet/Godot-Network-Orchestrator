extends LinkedData
class_name LinkedSetData

## Name of the property we want to change.
var key: String

## The value we want to set the property to.
# ! Value needs to be a standard Type.
var value: Variant

func _init(p_key: String, p_value: Variant) -> void:
	key = p_key
	value = p_value

func apply(applicable: Variant) -> void:
	applicable.set(key, value)

func to_dictionary() -> Dictionary:
	return {
		"ld_type": DATA_TYPE.SET,
		"key": key,
		"val": value
	}

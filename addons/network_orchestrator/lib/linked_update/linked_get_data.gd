extends LinkedData
class_name LinkedGetData

## The variable name of the property we want to get.
var key: String

## The next piece of LinkedData to traverse.
var next: LinkedData

func _init(p_key: String, p_next: LinkedData) -> void:
	key = p_key
	p_next = next

func apply(applicable: Variant) -> void:
	var next_applicable: Variant = applicable.get(key)
	next.apply(next_applicable)

func to_dictionary() -> Dictionary:
	return {
		"ld_type": DATA_TYPE.GET,
		"key": key,
		"next": next.to_dictionary()
	}

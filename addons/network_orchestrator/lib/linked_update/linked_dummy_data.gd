extends LinkedData
class_name LinkedDummyData

func apply(applicable: Variant) -> void:
	pass

func to_dictionary() -> Dictionary:
	return {
		"ld_type": DATA_TYPE.DUMMY,
	}

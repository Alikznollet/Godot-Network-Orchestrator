extends Node

## Dictionary of ClassNames to script instances of LinkState.
var STATES: Dictionary[StringName, GDScript] = {}

func _init() -> void:
	# Load all custom LinkState classes as scripts that can be instantiated.
	for cls in ProjectSettings.get_global_class_list():
		if cls.base == "LinkState":
			STATES[cls["class"]] = load(cls.path)

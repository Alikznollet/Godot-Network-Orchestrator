extends Resource
class_name LinkedStateRegistry
## Registry of all current states.

## ID to SCRIPT for any State class.
static var _id_to_script: Dictionary = {}

## SCRIPT to ID for any State class.
static var _script_to_id: Dictionary = {}

## Registers all State classes into the Registry with assigned ID.
static func _static_init() -> void:
	var state_classes: Array = []
	for cls in ProjectSettings.get_global_class_list():
		if cls.base == "LinkedState":
			state_classes.append(cls)

	state_classes.sort_custom(func(a, b): return a["class"] < b["class"])

	for i in range(state_classes.size()):
		var data = state_classes[i]
		var path = data.path
		var resource = load(path)

		_id_to_script[i] = resource
		_script_to_id[resource] = i

# -- PUBLIC -- #

## Returns the ID for a certain State class.
static func get_id(state_script: Script) -> int:
	assert(_script_to_id.has(state_script), "LinkedStateRegistry: No existing mapping for State %s." % state_script.get_global_name())

	return _script_to_id[state_script]

## Returns the script for a certain ID, null if the id does not exist.
static func get_script_from_id(id: int) -> Script:
	return _id_to_script.get(id, null)

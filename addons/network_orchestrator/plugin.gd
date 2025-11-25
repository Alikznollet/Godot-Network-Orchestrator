@tool
extends EditorPlugin

func _enter_tree() -> void:
	var icon = get_editor_interface().get_base_control().get_icon("MultiplayerSynchronizer", "EditorIcons")
	# Initialization of the plugin goes here.
	add_custom_type(
		"AuthoritativeNetworkOrchestrator",
		"NetworkOrchestrator",
		preload("lib/orchestrator/authoritative_network_orchestrator.gd"),
		icon
	)

	add_custom_type(
		"ClientNetworkOrchestrator",
		"NetworkOrchestrator",
		preload("lib/orchestrator/client_network_orchestrator.gd"),
		icon
	)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("AuthoritativeNetworkOrchestrator")
	remove_custom_type("ClientNetworkOrchestrator")

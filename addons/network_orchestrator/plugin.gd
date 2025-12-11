@tool
extends EditorPlugin

func _enable_plugin() -> void:
	add_autoload_singleton("LinkStateDB", "res://addons/network_orchestrator/lib/link_state/link_state_db.gd")

func _disable_plugin() -> void:
	remove_autoload_singleton("LinkStateDB")

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type(
		"AuthoritativeNetworkOrchestrator",
		"NetworkOrchestrator",
		preload("lib/orchestrator/authoritative_network_orchestrator.gd"),
		preload("MultiplayerSynchronizer.svg")
	)

	add_custom_type(
		"ClientNetworkOrchestrator",
		"NetworkOrchestrator",
		preload("lib/orchestrator/client_network_orchestrator.gd"),
		preload("MultiplayerSynchronizer.svg")
	)

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("AuthoritativeNetworkOrchestrator")
	remove_custom_type("ClientNetworkOrchestrator")

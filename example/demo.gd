extends Node2D

var network_orch: NetworkOrchestrator

func _ready() -> void:
	var args = OS.get_cmdline_args()
	var parsed := {}

	for arg in args:
		if arg.begins_with("--"):
			if arg.find("=") != -1:
				var parts = arg.substr(2).split("=")
				parsed[parts[0]] = parts[1]
			else:
				parsed[arg.substr(2)] = ""

	for key in parsed:
		var value: String = parsed[key]
		match key:
			"server":
				if value == "yes":
					network_orch = AuthoritativeNetworkOrchestrator.new()
					NetworkBus.network_orchestrator = network_orch
					multiplayer.peer_connected.connect(peer_connected)
					add_child(network_orch)
					peer_connected(1) # Connect the host themselves
				else:
					network_orch = ClientNetworkOrchestrator.new()
					NetworkBus.network_orchestrator = network_orch
					add_child(network_orch)
					%UpdFreq.editable = false
			"v":
				print("verbose")

	# -- Links for buttons -- #

	%UpdFreq.value_changed.connect(
		func (val): 
			network_orch.target_update_frequency = val
			%UpdFreqLabel.text = str(val)
	)

	%ArtificialLag.text_changed.connect(
		func (val):
			if network_orch is ClientNetworkOrchestrator: network_orch.artificial_lag = int(val)
	)

func peer_connected(id: int):
	var els := EntityLinkState.new()
	els.owner_pid = id
	els.global_position = Vector2.ZERO

	NetworkBus.network_orchestrator.game_state.add_state(els)

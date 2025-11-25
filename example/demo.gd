extends Node2D

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
					setup_server_peer()

					NetworkBus.network_orchestrator = AuthoritativeNetworkOrchestrator.new()
					multiplayer.peer_connected.connect(peer_connected)
					add_child(NetworkBus.network_orchestrator)
					peer_connected(1) # Connect the host themselves
				else:
					setup_client_peer()

					NetworkBus.network_orchestrator = ClientNetworkOrchestrator.new()
					add_child(NetworkBus.network_orchestrator)
					%UpdFreq.editable = false

	# -- Links for buttons -- #

	%UpdFreq.value_changed.connect(
		func (val): 
			NetworkBus.network_orchestrator.update_frequency = val
			%UpdFreqLabel.text = str(val)
	)

	%ArtificialLag.text_changed.connect(
		func (val):
			if NetworkBus.network_orchestrator is ClientNetworkOrchestrator: NetworkBus.network_orchestrator.artificial_lag = int(val)
	)

## Add an Entity for each peer that is connected.
func peer_connected(id: int):
	var els := EntityLinkState.new()
	els.owner_pid = id
	els.global_position = Vector2.ZERO

	NetworkBus.network_orchestrator.game_state.add_state(els)

## Sets up a single P2P server on port 9999.
func setup_server_peer():
	var peer := ENetMultiplayerPeer.new()

	# This status should be handled gracefully in a real setting
	var status := peer.create_server(9999)
	assert(status == OK, "AuthoritativeNetworkOrchestrator: Could not start server. Status: %d" % status)

	multiplayer.multiplayer_peer = peer

## Sets up a single P2P client on localhost port 9999.
func setup_client_peer(): 
	# Supposed to be replaced with SteamMultiplayerPeer in a real setting.
	var peer := ENetMultiplayerPeer.new()

	# In a real setting this error should be handled gracefully.
	var status := peer.create_client("127.0.0.1", 9999)
	assert(status == OK, "ClientNetworkOrchestrator: Could not connect to local server. Status: %d" % status)

	multiplayer.multiplayer_peer = peer

	await multiplayer.connected_to_server

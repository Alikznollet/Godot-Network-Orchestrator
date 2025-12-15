extends Node2D

var orchestrator: NetworkOrchestrator

var entities: Dictionary[int, DemoEntity] = {}

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

					orchestrator = AuthoritativeNetworkOrchestrator.new()
					orchestrator.node_added.connect(_node_added)
					multiplayer.peer_connected.connect(peer_connected)

					add_child(orchestrator)
					peer_connected(1) # Connect the host themselves
				else:
					setup_client_peer()

					orchestrator = ClientNetworkOrchestrator.new()
					orchestrator.node_added.connect(_node_added)
					
					add_child(orchestrator)
					%UpdFreq.editable = false
					%Unlink.disabled = true

	# -- Links for buttons -- #

	%UpdFreq.value_changed.connect(
		func (val): 
			orchestrator.target_update_frequency = val
			%UpdFreqLabel.text = str(val)
	)

	%ArtificialLag.text_changed.connect(
		func (val):
			if orchestrator is ClientNetworkOrchestrator: orchestrator.artificial_lag = int(val)
	)

## Triggered whenever the Orchestrator emits the node_added signal.
func _node_added(node: Node) -> void:
	if node is DemoEntity:
		entities[node.link_state.owner_pid] = node
		node.destroyed.connect(_entity_destroyed)
		add_child(node)

## Whenever an entity is supposed to be destroyed.
func _entity_destroyed(entity: DemoEntity) -> void:
	entities.erase(entity.link_state.owner_pid)

## Add an Entity for each peer that is connected.
func peer_connected(id: int):
	var els := EntityLinkState.new()
	els.owner_pid = id
	els.global_position = Vector2.ZERO

	if orchestrator is AuthoritativeNetworkOrchestrator:
		orchestrator.link_state(els)

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

func _on_unlink_pressed() -> void:
	var ls: LinkState = entities[multiplayer.get_unique_id()].link_state
	if orchestrator is AuthoritativeNetworkOrchestrator:
		orchestrator.unlink_state(ls)

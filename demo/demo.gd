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
				else:
					network_orch = ClientNetworkOrchestrator.new()
					%UpdFreq.editable = false

				add_child(network_orch)
			"v":
				print("verbose")

	# Add the local button
	add_child(DemoEntity.new())

	# -- Links for buttons -- #

	%UpdFreq.value_changed.connect(
		func (val): 
			network_orch.target_update_frequency = val
			%UpdFreqLabel.text = str(val)
	)

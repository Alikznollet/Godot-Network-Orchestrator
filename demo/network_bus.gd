extends Node
## Global Networking Node.

## Currently in use NetworkOrchestrator, null if none in use.
var network_orchestrator: NetworkOrchestrator

var enable_prediction: bool = true
var enable_reconciliation: bool = true
var enable_interpolation: bool = false
var enable_lag_compensation: bool = false

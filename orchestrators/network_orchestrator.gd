@abstract
extends Node
class_name NetworkOrchestrator
## Abstract interface defining a couple of important networking functions.

# -- Settings -- #

@export var enable_prediction: bool

@export var enable_reconciliation: bool

@export var enable_interpolation: bool

@export var enable_lag_compensation: bool

@abstract
func send_state() -> void

@abstract
func receive_state() -> void

extends KinematicBody2D
class_name Player

# Movement system
var move_vector setget set_move_vector, get_move_vector

# Energy System
export(float) var MAX_ENERGY: float = 100
export(float) var ENERGY_DRAIN_RATE: float = 1 # per sec
var energy: float = MAX_ENERGY setget energy_set

func _process(delta):
	calculate_energy(delta)

func set_move_vector(new_val):
	$PlayerStateMachine.move_vector = new_val

func get_move_vector():
	return $PlayerStateMachine.move_vector

func energy_set(new_var):
	energy = clamp(new_var, 0, MAX_ENERGY)

func calculate_energy(delta):
	energy -= delta * ENERGY_DRAIN_RATE

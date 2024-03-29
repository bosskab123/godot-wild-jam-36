extends KinematicBody2D
class_name Player

# Movement system
var move_vector setget set_move_vector, get_move_vector
var is_on_mud: bool = false

# Energy System
export(float) var MAX_ENERGY: float = 100
export(float) var ENERGY_DRAIN_RATE: float = 2 # per sec
var energy: float = MAX_ENERGY - 20 setget energy_set

# Sound system
onready var sound_eat_bad_apple: AudioStreamPlayer = $Sound/SoundEatBadApple as AudioStreamPlayer
onready var sound_eat_good_apple: AudioStreamPlayer = $Sound/SoundEatGoodApple as AudioStreamPlayer
onready var sound_walk_grass: AudioStreamPlayer = $Sound/SoundWalkGrass as AudioStreamPlayer
onready var sound_jump: AudioStreamPlayer = $Sound/SoundJump as AudioStreamPlayer

func _process(delta):
	calculate_energy(delta)

func set_move_vector(new_val):
	$PlayerStateMachine.move_vector = new_val

func get_move_vector():
	return $PlayerStateMachine.move_vector

func energy_set(new_var):
	energy = clamp(new_var, 0, MAX_ENERGY)
	$PlayerUI.on_energy_updated(energy)
	if energy <= 0:
		GameManager.emit_signal("game_over")

func calculate_energy(delta):
	energy_set(energy - delta * ENERGY_DRAIN_RATE)
	$PlayerUI.on_energy_updated(energy)

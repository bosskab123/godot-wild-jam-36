extends Node2D
class_name PlayerStateMachine

# movement system
var move_vector: Vector2
export(float) var MAX_X_SPEED: float = 300
export(float) var MAX_Y_SPEED: float = 400

var state#: PlayerState
onready var states: Dictionary = {
	"idle": $PlayerIdleState,
	"move": $PlayerMoveState,
	"air": $PlayerAirState,
}

func _ready():
	for state in states.values():
		state.setup(funcref(self, "change_state"), $"../AnimatedSprite", self)
	change_state("idle")

func change_state(new_state_name):
	if state != null:
		state.set_process(false)
		state.set_physics_process(false)
	if !states.has(new_state_name):
		printerr(states)
		printerr("NO STATE NAME: ", new_state_name)
		return
	state = states[new_state_name]
	state.set_process(true)
	state.set_physics_process(true)


extends Node2D
class_name PlayerStateMachine

# movement system
var move_vector: Vector2
var facing setget set_facing, get_facing

var state#: PlayerState
onready var states: Dictionary = {
	"idle": $PlayerIdleState,
	"move": $PlayerMoveState,
	"air": $PlayerAirState,
	"wall_hang": $PlayerWallHangState,
}

func _ready():
	change_state("idle")
	$WallCheckRay.add_exception(owner)

func change_state(new_state_name):
	if state != null:
		state.exit_state()
	if !states.has(new_state_name):
		printerr(states)
		printerr("NO STATE NAME: ", new_state_name)
		return
	state = states[new_state_name]
	state.enter_state()

func set_facing(new_facing):
	if new_facing == GlobalVars.FACING.RIGHT:
		set_scale(Vector2(1,1))
	else:
		set_scale(Vector2(-1,1))

func get_facing():
	if scale == Vector2(1,1):
		return GlobalVars.FACING.RIGHT
	elif scale == Vector2(-1,1):
		return GlobalVars.FACING.LEFT

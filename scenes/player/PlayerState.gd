extends Node2D
class_name PlayerState

# states: PlayerMoveState, PlayerIdleState, PlayerAirState
export(float) var MAX_X_SPEED: float = 300
export(float) var MAX_Y_SPEED: float = 400

var change_state: FuncRef
var animated_sprite: AnimatedSprite
var state_machine: PlayerStateMachine
var player: Player

func _ready():
	yield(get_parent(), "ready")
	change_state = funcref(get_parent(), "change_state")
	state_machine = get_parent()
	player = owner
	
func _physics_process(_delta):
	state_machine.move_vector.y += GlobalVars.GRAVITY
	state_machine.move_vector.x = clamp(state_machine.move_vector.x, -MAX_X_SPEED, MAX_X_SPEED)
	state_machine.move_vector.y = clamp(state_machine.move_vector.y, -MAX_Y_SPEED, MAX_Y_SPEED)
	
	player.move_and_slide(state_machine.move_vector, Vector2.UP)

func setup(change_state, animated_sprite, state_machine):
	set_process(false)
	set_physics_process(false)

extends Node2D
class_name PlayerState

# states: PlayerMoveState, PlayerIdleState, PlayerAirState, PlayerWallHangState
export(float) var JUMP_SPEED: float = 300
export(float) var MAX_X_SPEED: float = 300
export(float) var MAX_Y_SPEED: float = 400

var change_state: FuncRef
var state_machine: PlayerStateMachine
var player: Player

export(NodePath) onready var animated_sprite = get_node(animated_sprite) as AnimatedSprite

func _ready():
	set_process(false)
	set_physics_process(false)
	change_state = funcref(get_parent(), "change_state")
	state_machine = get_parent()
	player = owner

func enter_state():
	# print("enter: ", name)
	set_physics_process(true)
	set_process(true)

func exit_state():
	# print("exit: ", name)
	set_physics_process(false)
	set_process(false)

func _process(delta):
	if Input.is_action_pressed("move_right"):
		state_machine.facing = GlobalVars.FACING.RIGHT
	if Input.is_action_pressed("move_left"):
		state_machine.facing = GlobalVars.FACING.LEFT

func _physics_process(delta):
	physics_process(delta)

func physics_process(_delta):
	state_machine.move_vector.y += GlobalVars.GRAVITY
	state_machine.move_vector.x = clamp(state_machine.move_vector.x, -MAX_X_SPEED, MAX_X_SPEED)
	state_machine.move_vector.y = clamp(state_machine.move_vector.y, -MAX_Y_SPEED, MAX_Y_SPEED)
	
	state_machine.move_vector = player.move_and_slide(state_machine.move_vector, Vector2.UP)


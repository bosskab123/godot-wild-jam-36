extends PlayerState
class_name PlayerWallHangState

export(Vector2) var WALL_JUMP_VECTOR: Vector2 = Vector2(250,-300)
export(Vector2) var DETACH_VECTOR: Vector2 = Vector2(50,0)
export(float) var WALL_HANG_COOLDOWN: float = .7 # sec
export(NodePath) onready var wall_check_ray = get_node(wall_check_ray) as RayCast2D
var side_of_wall: int # determine which side is the wall on enter state

func enter_state():
	.enter_state()
	state_machine.move_vector = Vector2.ZERO
	wall_check_ray.enabled = false
	side_of_wall = state_machine.facing

func exit_state():
	.exit_state()
	state_machine.move_vector += DETACH_VECTOR * Vector2(-state_machine.facing, 1)
	yield(get_tree().create_timer(WALL_HANG_COOLDOWN), "timeout")
	wall_check_ray.enabled = true

# this disables normal physics when wallhang
func physics_process(delta):
	pass

func _process(_delta):
	if is_not_moving_toward_wall():
		change_state.call_func("air")
	
	if Input.is_action_just_pressed("jump"):
		state_machine.move_vector += WALL_JUMP_VECTOR * Vector2(-state_machine.facing, 1)
		change_state.call_func("air")

func is_not_moving_toward_wall():
	return(
		(side_of_wall== GlobalVars.FACING.LEFT and !Input.is_action_pressed("move_left"))
		or 
		(side_of_wall == GlobalVars.FACING.RIGHT and !Input.is_action_pressed("move_right"))
	)

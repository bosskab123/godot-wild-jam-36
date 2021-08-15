extends PlayerState
class_name PlayerWallHangState

export(Vector2) var WALL_JUMP_VECTOR: Vector2 = Vector2(250,-300)
export(Vector2) var DETACH_VECTOR: Vector2 = Vector2(50,0)
export(float) var WALL_HANG_COOLDOWN: float = .7 # sec
export(NodePath) onready var wall_check_ray = get_node(wall_check_ray) as RayCast2D

func enter_state():
	.enter_state()
	wall_check_ray.enabled = false
	is_movement_locked = true

func exit_state():
	.exit_state()
	is_movement_locked = false
	state_machine.move_vector += DETACH_VECTOR * -state_machine.facing
	yield(get_tree().create_timer(WALL_HANG_COOLDOWN), "timeout")
	wall_check_ray.enabled = true
	
func _process(_delta):
	print(state_machine.facing)
	print(GlobalVars.FACING.LEFT)
	print(GlobalVars.FACING.RIGHT)
	print(!Input.is_action_pressed("move_left"))
	print(!Input.is_action_pressed("move_right"))
	if ((state_machine.facing == GlobalVars.FACING.LEFT 
		and !Input.is_action_pressed("move_left"))
		
		or (state_machine.facing == GlobalVars.FACING.RIGHT 
		and !Input.is_action_pressed("move_right"))):
		print("contrast")
		change_state.call_func("air")
	
	if Input.is_action_just_pressed("jump"):
		change_state.call_func("air")
		state_machine.move_vector += WALL_JUMP_VECTOR * -state_machine.facing

extends PlayerState
class_name PlayerMoveState

export(float) var MOVE_SPEED: float = 100
export(float) var JUMP_SPEED: float = 300

func _process(_delta):
	if Input.is_action_pressed("move_right"):
		state_machine.move_vector.x += MOVE_SPEED
	if Input.is_action_pressed("move_left"):
		state_machine.move_vector.x -= MOVE_SPEED
	
	if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		state_machine.move_vector.x  = lerp(state_machine.move_vector.x, 0, 0.8)

	if Input.is_action_just_pressed("jump"):
		state_machine.move_vector.y = -JUMP_SPEED
		
	if !state_machine.get_parent().is_on_floor():
		change_state.call_func("air")

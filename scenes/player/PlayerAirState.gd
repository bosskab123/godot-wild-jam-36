extends PlayerState
class_name PlayerAirState

export(float) var MOVE_SPEED: float = 30

func _physics_process(delta):
	return

func _process(_delta):
	if Input.is_action_pressed("move_right"):
		state_machine.move_vector.x += MOVE_SPEED
	if Input.is_action_pressed("move_left"):
		state_machine.move_vector.x -= MOVE_SPEED

	if state_machine.get_parent().is_on_floor():
		change_state.call_func("move")

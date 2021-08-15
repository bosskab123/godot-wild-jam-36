extends PlayerState
class_name PlayerIdleState

func _physics_process(delta):
	return

func _process(_delta):
	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		change_state.call_func("move")

	if Input.is_action_just_pressed("jump") || !state_machine.get_parent().is_on_floor():
		change_state.call_func("air")

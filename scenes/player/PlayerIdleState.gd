extends PlayerState
class_name PlayerIdleState

func enter_state():
	.enter_state()
	animated_sprite.play("idle")

func physics_process(delta):
	.physics_process(delta)

func _process(_delta):
	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		change_state.call_func("move")

	if Input.is_action_just_pressed("jump"):
		state_machine.move_vector.y = -JUMP_SPEED
		player.sound_jump.play()
	
	if !player.is_on_floor():
		change_state.call_func("air")

	state_machine.move_vector.x  = lerp(state_machine.move_vector.x, 0, 0.2)


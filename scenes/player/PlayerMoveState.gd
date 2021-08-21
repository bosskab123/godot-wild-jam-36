extends PlayerState
class_name PlayerMoveState

export(float) var MOVE_SPEED: float = 100

func enter_state():
	.enter_state()
	animated_sprite.play("move")
	
func _process(_delta):
	if Input.is_action_pressed("move_right"):
		state_machine.move_vector.x += MOVE_SPEED
	if Input.is_action_pressed("move_left"):
		state_machine.move_vector.x -= MOVE_SPEED
	if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		change_state.call_func("idle")

	if Input.is_action_just_pressed("jump"):
		state_machine.move_vector.y = -JUMP_SPEED
		
	if !player.is_on_floor():
		change_state.call_func("air")

	handle_walk_sound()
	
func handle_walk_sound():
	if state_machine.move_vector.x != 0 and !player.is_on_mud and player.is_on_floor() and !player.sound_walk_grass.playing:
		print("start playing walk grass")
		player.sound_walk_grass.play()
	elif state_machine.move_vector.x == 0 or player.is_on_mud or !player.is_on_floor():
		print("stop playing walk grass")
		player.sound_walk_grass.stop()

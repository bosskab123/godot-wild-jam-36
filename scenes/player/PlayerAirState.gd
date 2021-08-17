extends PlayerState
class_name PlayerAirState

export(float) var MOVE_SPEED: float = 30
export(NodePath) onready var wall_check_ray = get_node(wall_check_ray) as RayCast2D

func _process(_delta):
	if Input.is_action_pressed("move_right"):
		state_machine.move_vector.x += MOVE_SPEED
	if Input.is_action_pressed("move_left"):
		state_machine.move_vector.x -= MOVE_SPEED
	
	check_jump_or_fall_anim()
	
	if player.is_on_floor():
		change_state.call_func("idle")
	
	if wall_check_ray.is_colliding() and is_moving_toward_facing():
		change_state.call_func("wall_hang")

func check_jump_or_fall_anim():
	if state_machine.move_vector.y >= 5 and animated_sprite.animation != "fall":
		animated_sprite.play("fall")
	elif state_machine.move_vector.y < 5 and animated_sprite.animation != "jump":
		animated_sprite.play("jump")

func is_moving_toward_facing():
	return (
		Input.is_action_pressed("move_left") and state_machine.facing == GlobalVars.FACING.LEFT
		or
		Input.is_action_pressed("move_right") and state_machine.facing == GlobalVars.FACING.RIGHT
	)

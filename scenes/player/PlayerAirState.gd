extends PlayerState
class_name PlayerAirState

export(float) var MOVE_SPEED: float = 30
export(NodePath) onready var wall_check_ray = get_node(wall_check_ray) as RayCast2D

func _physics_process(delta):
	return

func _process(_delta):
	if Input.is_action_pressed("move_right"):
		state_machine.move_vector.x += MOVE_SPEED
	if Input.is_action_pressed("move_left"):
		state_machine.move_vector.x -= MOVE_SPEED

	if player.is_on_floor():
		change_state.call_func("idle")
	
	if wall_check_ray.is_colliding():
		change_state.call_func("wall_hang")

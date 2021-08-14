extends KinematicBody2D

var move_vector: Vector2
export(float) var MOVE_SPEED: float = 100
export(float) var JUMP_SPEED: float = 300
export(float) var MAX_X_SPEED: float = 300
export(float) var MAX_Y_SPEED: float = 400

func _process(delta):
	if Input.is_action_pressed("move_right"):
		move_vector.x += MOVE_SPEED
	if Input.is_action_pressed("move_left"):
		move_vector.x -= MOVE_SPEED
	
	if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		move_vector.x = lerp(move_vector.x, 0, 0.8)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		move_vector.y = -JUMP_SPEED
	
func _physics_process(delta):
	move_vector.y += GlobalVars.GRAVITY
	move_vector.x = clamp(move_vector.x, -MAX_X_SPEED, MAX_X_SPEED)
	move_vector.y = clamp(move_vector.y, -MAX_Y_SPEED, MAX_Y_SPEED)
	
	move_and_slide(move_vector, Vector2.UP)

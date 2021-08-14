extends KinematicBody2D

var move_vector: Vector2
export(float) var MOVE_SPEED: float = 10
export(float) var MAX_X_SPEED: float = 50
export(float) var MAX_Y_SPEED: float = 50

func _process(delta):
	if Input.is_action_pressed("move_right"):
		move_vector += Vector2.RIGHT * MOVE_SPEED
	if Input.is_action_pressed("move_left"):
		move_vector += Vector2.LEFT * MOVE_SPEED
	
	move_vector.y -= GlobalVars.GRAVITY
	move_vector.x = clamp(move_vector.x, -MAX_X_SPEED, MAX_X_SPEED)
	move_vector.y = clamp(move_vector.y, -MAX_Y_SPEED, MAX_Y_SPEED)
	
	move_and_slide(move_vector)

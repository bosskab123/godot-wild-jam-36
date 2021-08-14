extends KinematicBody2D

var move_vector: Vector2
export(float) var MOVE_SPEED: float = 10
export(float) var MAX_MOVE_SPEED: float = 50

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("move_right"):
		move_vector += Vector2.RIGHT * MOVE_SPEED
	if Input.is_action_pressed("move_left"):
		move_vector += Vector2.LEFT * MOVE_SPEED
	
	move_vector.clamped(MAX_MOVE_SPEED)
	
	move_and_slide(move_vector)

	

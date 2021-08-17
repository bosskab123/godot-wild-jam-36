extends KinematicBody2D

export(float) var MOVE_SPEED: float = 75
export(float) var MAX_X_SPEED: float = 250
export(float) var MAX_Y_SPEED: float = 600
var FADEOUT_TIME: float = 0.5
var move_vector: Vector2
var eating: bool = false

func _physics_process(delta):
	if eating:
		queue_free()
	move_and_slide(move_vector, Vector2.UP)

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		move_vector += Vector2.LEFT * MOVE_SPEED + Vector2.DOWN * GlobalVars.GRAVITY
		move_vector.x = clamp(move_vector.x, -MAX_X_SPEED, MAX_X_SPEED)
		move_vector.y = clamp(move_vector.y, -MAX_Y_SPEED, MAX_Y_SPEED)

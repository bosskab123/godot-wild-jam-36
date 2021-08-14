extends Area2D

export(float) var MOVE_SPEED = 1

func _physics_process(delta):
	position.x += MOVE_SPEED

func _on_DeadWall_body_entered(body):
	if body.name == "Player":
		GameManager.emit_signal("game_over")

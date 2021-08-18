extends Area2D

export(float) var SPRING_FORCE: float = 2500

func _on_Spring_body_entered(body):
	if body.name == "Player":
		body.move_vector += Vector2.UP * SPRING_FORCE
		$AnimatedSprite.play("stretch")

func _on_Spring_body_exited(body):
	if body.name == "Player":
		$AnimatedSprite.play("shrink")

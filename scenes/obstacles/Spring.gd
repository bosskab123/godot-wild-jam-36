extends Area2D

export(float) var SPRING_FORCE: float = 2500
onready var sound_spring_pop: AudioStreamPlayer = $SoundSpringPop as AudioStreamPlayer

func _on_Spring_body_entered(body):
	if body.name == "Player":
		body.move_vector += Vector2.UP * SPRING_FORCE
		$AnimatedSprite.play("stretch")
		sound_spring_pop.play()

func _on_Spring_body_exited(body):
	if body.name == "Player":
		$AnimatedSprite.play("shrink")

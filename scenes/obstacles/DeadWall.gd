extends Area2D

export(float) var MOVE_SPEED = 1
onready var sound_walk: AudioStreamPlayer2D = $SoundWalk as AudioStreamPlayer2D

func _physics_process(delta):
	position.x += MOVE_SPEED

func _on_DeadWall_body_entered(body):
	if body.name == "Player":
		GameManager.emit_signal("game_over")
		body.hide()

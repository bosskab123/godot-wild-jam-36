extends Area2D

export(float) var SLOW_X_FACTOR = 0.6
export(float) var SLOW_Y_FACTOR = 0.9

onready var sound_walk_mud: AudioStreamPlayer2D = $SoundWalkMud as AudioStreamPlayer2D
onready var player = get_tree().get_root().find_node("Player",true,false) as Player

func _on_Mud_body_entered(body):
	if body.name == "Player":
		player.is_on_mud = true
		$AnimatedSprite.play("pressed")
		
func _on_Mud_body_exited(body):
	if body.name == "Player":
		player.is_on_mud = false
		$AnimatedSprite.stop()

func _physics_process(delta):
	if player.is_on_mud == true:
		player.move_vector.x *= SLOW_X_FACTOR
		player.move_vector.y *= SLOW_Y_FACTOR
		if player.move_vector.x != 0 and not sound_walk_mud.playing:
			sound_walk_mud.play()
		elif player.move_vector.x == 0 and sound_walk_mud.playing:
			sound_walk_mud.stop()
	else:
		sound_walk_mud.stop()

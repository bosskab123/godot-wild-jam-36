extends Area2D

export(float) var SLOW_X_FACTOR = 0.6
export(float) var SLOW_Y_FACTOR = 0.95
var player_on_mud: bool = false
onready var player = get_tree().get_root().find_node("Player",true,false)

func _on_Mud_body_entered(body):
	if body.name == "Player":
		player_on_mud = true
		
func _on_Mud_body_exited(body):
	if body.name == "Player":
		player_on_mud = false

func _process(delta):
	if player_on_mud == true:
		if player != null:
			player.move_vector.x *= SLOW_X_FACTOR
			player.move_vector.y *= SLOW_Y_FACTOR

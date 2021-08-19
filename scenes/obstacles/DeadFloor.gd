extends Area2D

onready var player = get_tree().get_root().find_node("Player",true,false) as Player

func _physics_process(delta):
	position.x = player.position.x
	position.y = 300

func _on_DeadFloor_body_entered(body):
	if body.name == "Player":
		GameManager.emit_signal("game_over")

extends Area2D

export(float) var SPRING_FORCE: float = 1000
onready var player = get_tree().get_root().find_node("Player",true,false) as Player

func _on_Spring_body_entered(body):
	if player:
		player.move_vector += Vector2.UP * SPRING_FORCE

extends Area2D

export(float) var SPRING_FORCE: float = 1000
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Spring_body_entered(body):
	var player = get_node("../Player")
	
	if player != null:
		player.move_vector += Vector2.UP * SPRING_FORCE
	pass

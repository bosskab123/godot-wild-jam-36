extends Area2D

signal player_on_spring

export(float) var SPRING_FORCE: float = 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	emit_signal("player_on_pat")
	
	var player = get_tree().get_root().get_node("Player")
	
	if player != null:
		player.move_vector += Vector2.UP * SPRING_FORCE
	pass

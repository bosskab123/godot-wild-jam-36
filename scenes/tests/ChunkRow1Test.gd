extends Node

var current_chunk: int = 0
var total_chunk: int = 20
var current_scene: Node2D
onready var player: Player = $Player

func change_scene():
	# change scene
	if current_scene:
		current_scene.queue_free()
	var scene_path = "res://scenes/chunks/1_row/Chunk" + str(current_chunk) + "Row1.tscn"
	var scene = load(scene_path).instance()
	current_scene = scene
	add_child(scene)
	
	# reposition player
	player.position = Vector2(60,148)

func _process(delta):
	$ChunkLabel.text = "Chunk" + str(current_chunk)
	if Input.is_action_just_pressed("next_chunk"):
		current_chunk += 1
		current_chunk = int(clamp(current_chunk,1,total_chunk))
		change_scene()
	elif Input.is_action_just_pressed("previous_chunk"):
		current_chunk -= 1
		current_chunk = int(clamp(current_chunk,1,total_chunk))
		change_scene()

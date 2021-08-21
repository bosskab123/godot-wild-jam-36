extends Node
signal game_start
signal game_over

export(PackedScene) var GAME_SCENE: PackedScene
export(PackedScene) var END_SCENE: PackedScene

var chunk_rows: Array = [] # Each element Contains array of chunkRow
var initial_chunk_scene: PackedScene = preload("res://scenes/chunks/InitialChunk.tscn")

func _ready():
	randomize()
	connect("game_start", self, "on_game_start")
	connect("game_over", self, "on_game_over")

func load_chunk():
	chunk_rows = []
	for row in range(1,GlobalVars.ROWS_NUMBER+1):
		var chunk_row = []
		for chunk in range(1,GlobalVars.CHUNKS_NUMBER+1):
			var chunk_instance: Node2D = load("res://scenes/chunks/"+str(row)+"_row/Chunk"+str(chunk)+"Row"+str(row)+".tscn").instance()
			chunk_instance.position.x = -1000 * chunk
			chunk_row.append(chunk_instance)
		chunk_rows.append(chunk_row)

func on_game_start():
	get_tree().paused = false
	load_chunk()
	get_tree().change_scene_to(GAME_SCENE)

func on_game_over():
	# Play game over sound
	var sound_game_over = get_tree().get_root().find_node("SoundGameOver",true,false)
	sound_game_over.play()
	# Pause every object in the scene
	# ("Game Over")
	get_tree().paused = true
	# Show end game UI
	var end_game_ui_instance = END_SCENE.instance()
	add_child(end_game_ui_instance)

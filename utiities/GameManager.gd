extends Node
signal game_start
signal game_over

export(PackedScene) var GAME_SCENE: PackedScene
export(PackedScene) var END_SCENE: PackedScene

var chuck_row_map: Dictionary = {
	"1_1": "res://scenes/chunks/1_row/Chunk1Row1.tscn",
	"2_1": "res://scenes/chunks/1_row/Chunk2Row1.tscn",
	"3_1": "res://scenes/chunks/1_row/Chunk3Row1.tscn",
	"4_1": "res://scenes/chunks/1_row/Chunk4Row1.tscn",
	"5_1": "res://scenes/chunks/1_row/Chunk5Row1.tscn",
	"6_1": "res://scenes/chunks/1_row/Chunk6Row1.tscn",
	"7_1": "res://scenes/chunks/1_row/Chunk7Row1.tscn",
	"8_1": "res://scenes/chunks/1_row/Chunk8Row1.tscn",
	"9_1": "res://scenes/chunks/1_row/Chunk9Row1.tscn",
	"10_1": "res://scenes/chunks/1_row/Chunk10Row1.tscn",	
	
	"1_2": "res://scenes/chunks/2_row/Chunk1Row2.tscn",
	"2_2": "res://scenes/chunks/2_row/Chunk2Row2.tscn",
	"3_2": "res://scenes/chunks/2_row/Chunk3Row2.tscn",
	"4_2": "res://scenes/chunks/2_row/Chunk4Row2.tscn",
	"5_2": "res://scenes/chunks/2_row/Chunk5Row2.tscn",
	"6_2": "res://scenes/chunks/2_row/Chunk6Row2.tscn",
	"7_2": "res://scenes/chunks/2_row/Chunk7Row2.tscn",
	"8_2": "res://scenes/chunks/2_row/Chunk8Row2.tscn",
	"9_2": "res://scenes/chunks/2_row/Chunk9Row2.tscn",
	"10_2": "res://scenes/chunks/2_row/Chunk10Row2.tscn",
}

var chunk_rows: Array = [] # Each element Contains array of chunkRow

func _ready():
	connect("game_start", self, "on_game_start")
	connect("game_over", self, "on_game_over")

func load_map():
	for row in GlobalVars.ROWS_NUMBER:
		chunk_rows.append([])
	for chunck_row_name in chuck_row_map.keys():
		chunck_row_name = chunck_row_name as String
		var chuck_num = chunck_row_name.split("_")[0]
		var row_num = int(chunck_row_name.split("_")[1])
		chunk_rows[row_num-1].append(load(chuck_row_map[chunck_row_name]))

func on_game_start():
	if(chunk_rows == []):
		var load_map = load_map()
		if load_map is GDScriptFunctionState:
			load_map = yield(load_map, "completed")
	get_tree().change_scene_to(GAME_SCENE)

func on_game_over():
	print("Game Over")
	get_tree().paused = true
		
	var end_game_ui_instance = END_SCENE.instance()
	add_child(end_game_ui_instance)

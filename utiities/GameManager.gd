extends Node
signal game_start
signal game_over

export(PackedScene) var GAME_SCENE: PackedScene

func _ready():
	connect("game_start", self, "on_game_start")
	connect("game_over", self, "on_game_over")
	
func on_game_start():
	get_tree().change_scene_to(GAME_SCENE)

func on_game_over():
	print("Game Over")
	get_tree().paused = true

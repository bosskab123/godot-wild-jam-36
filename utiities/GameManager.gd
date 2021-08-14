extends Node
signal game_start
signal game_over

func _ready():
	connect("game_over", self, "on_game_over")

func on_game_over():
	print("Game Over")
	get_tree().paused = true

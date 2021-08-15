extends CanvasLayer

func _on_PlayButton_pressed():
	GameManager.emit_signal("game_start")

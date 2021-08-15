extends CanvasLayer

func _on_RestartButton_pressed():
	GameManager.emit_signal("game_start")
	queue_free()

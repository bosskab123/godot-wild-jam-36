extends CanvasLayer

func _on_RestartButton_pressed():
	GameManager.emit_signal("game_start")
	queue_free()


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://scenes/uis/MainMenuUI.tscn")
	queue_free()

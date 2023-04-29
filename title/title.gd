extends Control


signal change_scene(to: String)


func _on_start_pressed() -> void:
	LevelsManager.start_game()
	visible = false


func _on_exit_pressed():
	get_tree().quit()

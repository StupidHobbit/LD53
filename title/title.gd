extends Control


signal change_scene(to: String)


func _on_start_pressed() -> void:
	LevelsManager.start_game()
	visible = false

func _input(event):
	if Input.is_action_just_pressed("pause") and LevelsManager.game_is_active:
		LevelsManager.pause_game()
		visible = true
		$VBoxContainer/Start.visible = false
		$VBoxContainer/Continue.visible = true
		

func _on_exit_pressed():
	get_tree().quit()


func _on_continue_pressed():
	LevelsManager.continue_game()
	visible = false

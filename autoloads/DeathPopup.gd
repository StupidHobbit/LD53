extends PopupPanel

@onready var re_start: Button = $VBoxContainer/ReStart

func _ready():
	visible = false
	hide()
	
	re_start.pressed.connect(_on_re_start_pressed)
	$VBoxContainer/Exit.pressed.connect(_exit_on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		popup_centered()


func _on_re_start_pressed():
	print("Hello")
	LevelsManager.restart_game()
	visible = false


func _exit_on_pressed():
	get_tree().quit()

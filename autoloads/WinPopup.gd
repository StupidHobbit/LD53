extends PopupPanel

@onready var re_start: Button = $VBoxContainer/ReStart

func _ready():
	hide()
	$VBoxContainer/Exit.pressed.connect(_exit_on_pressed)

func _exit_on_pressed():
	get_tree().quit()

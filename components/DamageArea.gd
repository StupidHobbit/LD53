extends Area3D
class_name DamageArea

@export var damage: int = 1
@export var cooldown: float = 1

@onready var timer = $Timer

func _ready():
	pass # Replace with function body.

func is_on_cooldown() -> bool:
	return not timer.is_stopped()
	
func damage_target(target: Node):
	timer.start(cooldown)
	

func _process(delta):
	pass

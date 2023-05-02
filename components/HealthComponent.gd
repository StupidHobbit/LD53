extends Node
class_name HealthComponent

signal took_damage(damage: float)
signal health_depleted()
signal max_hp_changed()

@export var max_hp: float
var current_hp: float

# Called when the node enters the scene tree for the first time.
func _ready():
	current_hp = max_hp
	
func add_vitality(value: float):
	current_hp *= value
	max_hp *= value
	max_hp_changed.emit()

func take_damage(damage: float):
	if current_hp == 0:
		return
	current_hp = clampf(current_hp - damage, 0, max_hp)
	took_damage.emit(damage)
	if current_hp == 0:
		health_depleted.emit()

extends Resource
class_name AbilitySlotData

@export var ability_data: AbilityData
var current_cooldown: float = 0

func update_cooldown(delta: float):
	current_cooldown = clampf(0, current_cooldown - delta, ability_data.cooldown)

func is_ready() -> bool:
	return current_cooldown == 0
	
func use():
	current_cooldown = ability_data.cooldown

func cooldown_percent() -> float:
	return current_cooldown / ability_data.cooldown

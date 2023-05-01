extends PanelContainer
class_name PowerUpPopup

@export var all_powerups: Array[AbilityData]
@export var number_to_choose: int = 3

const Slot = preload("res://autoloads/power_up_slot.tscn")
@onready var ability_container = $MarginContainer/AbilityContainer

var player: Player
var abilities: AbilitiesSystem

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	player = get_parent()
	hide()


func choose_power_up():
	show()
	get_tree().paused = true
	abilities = player.abilities_system
	
	var powerups = Array()
	for p in all_powerups:
		if abilities.abilities_index.has(p.slug):
			continue
		powerups.append(p)
	powerups.shuffle()
	powerups.resize(min(number_to_choose, powerups.size()))

	for c in ability_container.get_children():
		c.queue_free()
	
	for p in powerups:
		var slot = Slot.instantiate()
		ability_container.add_child(slot)
		slot.set_slot_data(PowerUpSlotData.new(p))
		slot.choose.connect(_on_choose_ability)

func _on_choose_ability(ability: AbilityData):
	abilities.add_ability(ability)
	hide()
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

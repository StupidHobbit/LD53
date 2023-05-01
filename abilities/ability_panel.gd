extends PanelContainer


const Slot = preload("res://abilities/ability_slot.tscn")

@onready var ability_container: HBoxContainer = $MarginContainer/SpellContainer

func set_player_ability_panel_data(ability_panel_data: AbilityPanelData):
	populate_ability_container(ability_panel_data.slot_datas)

func populate_ability_container(slot_datas: Array[AbilitySlotData]):
	for c in ability_container.get_children():
		c.queue_free()
	
	var index = 1
	for slot_data in slot_datas:
		var slot = Slot.instantiate()
		ability_container.add_child(slot)

		if slot_data != null:
			slot.set_slot_data(slot_data)
		slot.set_index(index)
		index += 1

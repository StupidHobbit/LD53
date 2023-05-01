extends PanelContainer

@onready var texture_rect = $MarginContainer/TextureRect
@onready var index_label = $IndexLabel
@onready var cooldown_progress = $CooldownProgress

func set_slot_data(slot_data: AbilitySlotData):
	var ability_data = slot_data.ability_data
	texture_rect.texture = ability_data.texture
	tooltip_text = "%s\n%s" % [ability_data.name, ability_data.description]
	cooldown_progress.value = slot_data.cooldown_percent()

func set_index(index: int):
	index_label.text = " %d" % index

extends PanelContainer

signal choose(ability: AbilityData)

@onready var ability_icon = $MarginContainer/VSplitContainer/HSplitContainer/AbilityIcon
@onready var title_label = $MarginContainer/VSplitContainer/HSplitContainer/TitleLabel
@onready var description_label = $MarginContainer/VSplitContainer/DescriptionLabel
@onready var button = $MarginContainer/VSplitContainer/HSplitContainer/Button

var ability_data: AbilityData

func set_slot_data(slot_data: PowerUpSlotData):
	ability_data = slot_data.ability_data
	ability_icon.texture = ability_data.texture
	tooltip_text = "%s\n%s" % [ability_data.name, ability_data.description]
	title_label.text = ability_data.name
	description_label.text = ability_data.description

func _ready():
	button.pressed.connect(_on_click)

func _on_click():
	choose.emit(ability_data)

extends CharacterBody3D
class_name Player


@export var speed := 4.0
@export var target: Target
@export var dash_distance: float = 10
@export var abilities_panel: AbilityPanelData = AbilityPanelData.new()

@onready var target_arrow = $TargetArrow
@onready var red_hood = $RedHood
@onready var health_component: HealthComponent = $HealthComponent
@onready var abilities_system = $AbilitiesSystem
@onready var statuses_component: StatusesComponent = $StatusesComponent
@onready var hurt_box_component = $HurtBoxComponent
@onready var health_bar = $HealthBar
@onready var cast_point = $RedHood/CastPoint
@onready var power_up_popup: PowerUpPopup = $PowerUpPopup
@onready var animation_player = $RedHood/AnimationPlayer
@onready var bitten_sound = $BittenSound

var has_dash_boost: bool = false
var last_input: Vector2
var target_arrow_original_position: Vector3

func _ready():
	health_component.health_depleted.connect(_on_health_depleted)
	health_component.took_damage.connect(_on_damage)
	health_component.max_hp_changed.connect(_on_max_hp_change)
	hurt_box_component.area_entered.connect(_on_hurtbox_area_entered)
	health_bar.max_value = health_component.max_hp
	health_bar.value = health_component.max_hp
	target_arrow_original_position = target_arrow.position
	init_abilities()
	

func init_abilities():
	var _abilities_panel: AbilityPanelData = AbilityPanelData.new()
	_abilities_panel.slot_datas = abilities_panel.slot_datas.duplicate()
	abilities_system.init_abilities_panel(_abilities_panel)


func _physics_process(delta: float) -> void:
	var current_speed = speed * statuses_component.get_speed()
	var input := Input.get_vector("left", "right", "up", "down").normalized()

	if input:
		last_input = input
		animation_player.play("Running")
	else:
		animation_player.play("Idle")

	if has_dash_boost:
		has_dash_boost = false
		position += dash_distance * Vector3(last_input.x, 0, last_input.y)
	
	red_hood.rotation.y = atan2(last_input.x, last_input.y)
	velocity = Vector3(input.x, 0, input.y) * current_speed
	move_and_slide()

func _process(delta: float):
	update_target()
	
func update_target():
	if target == null:
		return
	var target_position = target.position
	var angle = atan2(position.x - target_position.x, target_position.z - position.z)
	target_arrow.rotation.z = angle
	#target_arrow.position = target_arrow_original_position + position

func _on_damage(damage: float):
	health_bar.value = health_component.current_hp
	if damage >= 1:
		bitten_sound.play()

func _on_max_hp_change():
	health_bar.max_value = health_component.max_hp
	health_bar.value = health_component.current_hp

func _on_hurtbox_area_entered(area: Area3D):
	if area is Target:
		if target.is_final:
			LevelsManager.finish_game()
			return
		power_up_popup.choose_power_up()
		LevelsManager.call_deferred("finish_level")

func _on_health_depleted():
	DeathPopup.show()
	LevelsManager.pause_game()

func dash():
	has_dash_boost = true

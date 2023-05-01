extends CharacterBody3D
class_name Player


@export var speed := 4.0
@export var target: Target
@export var dash_distance: float = 10

@onready var target_arrow = $TargetArrow

@onready var health_component: HealthComponent = $HealthComponent
@onready var abilities_system = $AbilitiesSystem
@onready var statuses_component: StatusesComponent = $StatusesComponent
@onready var hurt_box_component = $HurtBoxComponent
@onready var health_bar = $HealthBar
@onready var cast_point = $CastPoint
@onready var power_up_popup: PowerUpPopup = $PowerUpPopup

var has_dash_boost: bool = false

func _ready():
	health_component.health_depleted.connect(_on_health_depleted)
	health_component.took_damage.connect(_on_damage)
	hurt_box_component.area_entered.connect(_on_hurtbox_area_entered)
	health_bar.max_value = health_component.max_hp
	health_bar.value = health_component.max_hp

func _physics_process(delta: float) -> void:
	var current_speed = speed * statuses_component.get_speed()
	print(current_speed)
	var input := Input.get_vector("left", "right", "up", "down").normalized()
	
	if has_dash_boost:
		has_dash_boost = false
		position += dash_distance * Vector3(input.x, 0, input.y)
	
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

func _on_damage(damage: int):
	health_bar.value = health_component.current_hp

func _on_hurtbox_area_entered(area: Area3D):
	if area is Target:
		power_up_popup.choose_power_up()
		LevelsManager.call_deferred("finish_level")

func _on_health_depleted():
	DeathPopup.show()
	LevelsManager.pause_game()

func dash():
	has_dash_boost = true

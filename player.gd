extends CharacterBody3D
class_name Player


@export var speed := 5.0
@export var has_acceleration := false
@export var acceleration := 1
@export var deacceleration := 1
@export var target: Target

@onready var target_arrow = $TargetArrow

@onready var health_component: HealthComponent = $HealthComponent
@onready var hurt_box_component = $HurtBoxComponent

func _ready():
	health_component.took_damage.connect(_on_damage)
	hurt_box_component.area_entered.connect(_on_hurtbox_area_entered)

func _physics_process(delta: float) -> void:
	var input := Input.get_vector("left", "right", "up", "down").normalized()
	if has_acceleration:
		if input.length() == 0.0:
			velocity = velocity.move_toward(Vector3.ZERO, deacceleration * delta)
		else:
			velocity = velocity.move_toward(Vector3(input.x, 0, input.y) * speed, acceleration * delta)
	else:
		velocity = Vector3(input.x, 0, input.y) * speed
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
	print(damage)

func _on_hurtbox_area_entered(area: Area3D):
	if area is Target:
		LevelsManager.finish_level()

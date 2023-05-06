extends CharacterBody3D

@export var speed: float = 4 

@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player: AnimationPlayer = $model/AnimationPlayer
@onready var damage_area = $DamageArea
@onready var status_mesh = $StatusMesh
@onready var statuses_component = $StatusesComponent
@onready var death_audio = $DeathAudio
@onready var bite_audio = $BiteAudio

@onready var fire_material = preload("res://projectiles/fire_material.tres")
@onready var ice_material = preload("res://projectiles/ice_material.tres")

var player: Player
var is_biting: bool = false
var is_dying: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	status_mesh.hide()
	health_component.health_depleted.connect(_on_health_depleted)
	health_component.took_damage.connect(_on_took_damage)
	damage_area.did_damage.connect(_on_damage)
	animation_player.animation_finished.connect(_on_animation_finished)
	statuses_component.status_added.connect(on_status_add)

func on_status_add(status: Status):
	print(status.type, " ", Status.StatusType.FIRE)
	if status.type == Status.StatusType.FIRE:
		status_mesh.show()
		status_mesh.material_override = fire_material
	if status.type == Status.StatusType.ICE:
		status_mesh.show()
		status_mesh.material_override = ice_material
		

func _on_animation_finished(name: String):
	if name == "W_Bite":
		is_biting = false
	if name == "W_Dead":
		queue_free()

func _on_damage():
	is_biting = true
	animation_player.play("W_Bite")
	bite_audio.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_dying:
		return
	var player_position = player.position
	var diff_x = player_position.x - position.x
	var diff_y = player_position.z - position.z
	velocity = Vector3(diff_x, 0, diff_y).normalized() * speed * statuses_component.get_speed()
	rotation.y = atan2(diff_x, diff_y) + PI / 2

func _physics_process(delta):
	if is_dying:
		return
	if not is_biting:
		if get_real_velocity().length() > 0.5:
			animation_player.play("W_Running")
		else:
			animation_player.play("W_Idle")
	move_and_slide()

func _on_health_depleted():
	is_dying = true
	damage_area.queue_free()
	animation_player.play("W_Dead")
	death_audio.play()

func _on_took_damage(damage: int):
	if damage > 0.1:
		print(damage)

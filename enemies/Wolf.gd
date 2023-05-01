extends CharacterBody3D

@export var speed: float = 4 

@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player: AnimationPlayer = $model/AnimationPlayer
@onready var damage_area = $DamageArea

var player: Player
var is_biting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health_component.health_depleted.connect(_on_health_depleted)
	health_component.took_damage.connect(_on_took_damage)
	damage_area.did_damage.connect(_on_damage)
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(name: String):
	if name == "W_Bite":
		is_biting = false

func _on_damage():
	is_biting = true
	animation_player.play("W_Bite")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_position = player.position
	var diff_x = player_position.x - position.x
	var diff_y = player_position.z - position.z
	velocity = Vector3(diff_x, 0, diff_y).normalized() * speed
	rotation.y = atan2(diff_x, diff_y) + PI / 2

func _physics_process(delta):
	if not is_biting:
		if get_real_velocity().length() > 0.5:
			animation_player.play("W_Running")
		else:
			animation_player.play("W_Idle")
	move_and_slide()

func _on_health_depleted():
	queue_free()

func _on_took_damage(damage: int):
	print(damage)

extends Area3D
class_name Projectile

signal landed()
signal destroyed()

@export var data: ProjectileData
@export var max_lifetime: float = 100

var lifetime: float = 0
var velocity: Vector3
var statuses: Array[Status]

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	position += velocity * delta

func _on_body_entered(b: Node3D):
	landed.emit()
	destroyed.emit()
	queue_free()
	
func _process(delta: float):
	lifetime += delta
	if lifetime >= max_lifetime:
		destroyed.emit()
		queue_free()
	

func get_stats() -> ProjectileData:
	return data

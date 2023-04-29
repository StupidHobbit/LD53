extends Node
class_name EnemySpawner

@export var spawn_range: float = 10 
@export var enemy_scene: PackedScene
@export var player: Player
@export var cooldown: float
@export var max_amount: int = 10

@onready var spawn_timer = $SpawnTimer

var current_amount: int = 0
var world: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer.timeout.connect(spawn)
	world = get_parent()
	spawn_timer.start(cooldown)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn():
	if current_amount >= max_amount:
		return
	var enemy = enemy_scene.instantiate()
	var angle = randf_range(0, 2 * PI)
	enemy.position = Vector3(cos(angle), 0, sin(angle)) * spawn_range
	enemy.player = player
	world.add_child(enemy)
	current_amount += 1
	enemy.tree_exited.connect(_enemy_deleted)

func _enemy_deleted():
	current_amount -= 1

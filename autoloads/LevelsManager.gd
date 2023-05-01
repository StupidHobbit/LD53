extends Node

@onready var player_scene = preload("res://player.tscn")
@onready var spawner_scene = preload("res://spawners/EnemySpawner.tscn")
@onready var target_scene = preload("res://target/target.tscn")
@onready var empty_level_scene = preload("res://levels/empty_level.tscn")
@onready var wolf_scene = preload("res://enemies/regular_wolf.tscn")

var player: Player
var current_level: Node3D
var main: Node
var current_level_number: int = 1
var game_is_active: bool = false

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start_game():
	player = player_scene.instantiate()
	current_level = _create_level()
	current_level.add_child(player)
	game_is_active = true

func restart_game():
	current_level.get_tree().paused = false
	current_level.queue_free()
	current_level_number = 1
	player.init_abilities()
	start_game()

func finish_level():
	var old_level = current_level
	current_level = _create_level()
	player.reparent(current_level)
	old_level.queue_free()
	
	
func pause_game():
	current_level.get_tree().paused = true
	game_is_active = false
	
	
func continue_game():
	current_level.get_tree().paused = false
	game_is_active = true
	
	
func _create_level():
	var spawner: EnemySpawner = spawner_scene.instantiate()
	spawner.max_amount = current_level_number * 3
	spawner.cooldown = 5 / sqrt(current_level_number)
	spawner.spawn_range = 20
	spawner.player = player
	spawner.enemy_scene = wolf_scene
	
	var target = target_scene.instantiate()
	var target_distance = 30 * sqrt(current_level_number)
	var target_angle = randf_range(0, 2 * PI)
	target.position = Vector3(target_distance * cos(target_angle), 0, target_distance * sin(target_angle))
	player.target = target
	player.position = Vector3.ZERO
	
	current_level = empty_level_scene.instantiate()
	current_level.add_child(spawner)
	current_level.add_child(target)
	
	main.add_child(current_level)
	
	current_level_number += 1
	
	return current_level

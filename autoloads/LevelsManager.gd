extends Node

@onready var player_scene = preload("res://player.tscn")
@onready var spawner_scene = preload("res://spawners/EnemySpawner.tscn")
@onready var target_scene = preload("res://target/target.tscn")
@onready var wolf_scene = preload("res://enemies/regular_wolf.tscn")

@onready var levels = [
	preload("res://levels/level1.tscn"),
	preload("res://levels/level_2.tscn"),
	preload("res://levels/level_3.tscn"),
	preload("res://levels/level_4.tscn"),
	preload("res://levels/level_5.tscn"),
]


var player: Player
var current_level: Node3D
var main: Node
var current_level_number: int = 1
var game_is_active: bool = false
var next_level_scene: PackedScene

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
	
func finish_game():
	pause_game()
	$WinPopup.show()
	$WinPopup.popup_centered()

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
	player.position = Vector3.ZERO
	
	current_level = _get_current_level_scene().instantiate()
	
	main.add_child(current_level)
	
	for o in current_level.get_children():
		if o is EnemySpawner:
			o.player = player
		if o is Target:
			player.target = o
		
	current_level_number += 1
	
	return current_level
	
func _get_current_level_scene() -> PackedScene:
	return levels[current_level_number - 1]

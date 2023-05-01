extends Node
class_name AbilitiesSystem

@export var abilities_panel: AbilityPanelData = AbilityPanelData.new()
@export var statuses_component: StatusesComponent:
	set(value):
		statuses_component = value
		update_configuration_warnings()
		

@onready var ability_panel = $AbilityPanel

var abilities_index: Dictionary
var enemies_query: EnemiesQuery = EnemiesQuery.new()
var player: Player
var world: Node

var rock_projectile = preload("res://projectiles/rock_projectile.tscn")
var poison_cloud_projectile = preload("res://projectiles/poison_cloud_projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
	world = player.get_parent()
	player.tree_entered.connect(_on_level_change)
	update_configuration_warnings()
	for slot in abilities_panel.slot_datas:
		abilities_index[slot.ability_data.slug] = slot.ability_data
		for s in slot.ability_data.statuses:
			statuses_component.add_status(s)

func _on_level_change():
	world = player.get_parent()

func add_ability(ability: AbilityData):
	var slot = AbilitySlotData.new()
	slot.ability_data = ability
	abilities_panel.slot_datas.append(slot)
	abilities_index[ability.slug] = ability
	for s in ability.statuses:
		statuses_component.add_status(s)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	update_cooldowns(delta)
	_process_autocast()
	_process_active_abilities()
	
	ability_panel.set_player_ability_panel_data(abilities_panel)

func _process_autocast():
	enemies_query.init(player, get_tree().get_nodes_in_group("enemy"))
	for slot in abilities_panel.slot_datas:
		var ability_data = slot.ability_data
		if ability_data == null or not ability_data.autocast or ability_data.passive:
			continue
		if not slot.is_ready():
			continue
		if _autocast_implementation(ability_data):
			slot.use()
			
func _process_active_abilities():
	for slot in abilities_panel.slot_datas:
		var ability_data = slot.ability_data
		if ability_data == null or ability_data.autocast or ability_data.passive:
			continue
		if not slot.is_ready():
			continue
		if not Input.is_action_just_pressed(ability_data.slug):
			continue
		if _active_ability_implementation(ability_data):
			slot.use()

func _active_ability_implementation(ability_data: AbilityData) -> bool:
	match ability_data.slug:
		"dash":
			player.dash()
			return true
		_:
			push_error("Unknown ability", ability_data.slug)
	return false

func _autocast_implementation(ability_data: AbilityData) -> bool:
	if ability_data.range < enemies_query.get_distance_to_closest_enemy():
		return false
	
	match ability_data.slug:
		"rock":
			var p = make_projectile(rock_projectile, ability_data, enemies_query.get_closest_enemy().position)
			return true
		"poison_cloud":
			var p = make_projectile(poison_cloud_projectile, ability_data, enemies_query.get_closest_enemy().position)
			return true
		_:
			push_error("Unknown ability", ability_data.slug)
	return false
	
func make_projectile(projectile_scene: PackedScene, ability: AbilityData, target_position: Vector3) -> Projectile:
	var projectile = projectile_scene.instantiate()
	projectile.data = ability.projectile
	world.add_child(projectile)
	projectile.global_position = player.cast_point.global_position
	projectile.velocity = Vector3(target_position.x - player.position.x, 0, target_position.z - player.position.z).normalized() * ability.projectile.speed
	return projectile

func update_cooldowns(delta: float):
	for slot in abilities_panel.slot_datas:
		slot.update_cooldown(delta)

func _get_configuration_warnings():
	if statuses_component == null:
		return ["Provide reference to StatusesComponent"]
	else:
		return []

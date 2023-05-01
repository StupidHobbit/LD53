extends Resource
class_name EnemiesQuery

var _player: Player
var _enemies: Array
var _closest_enemy: Node3D
var _distance_to_closest_enemy: float
var _cached: bool

func init(player: Player, enemies: Array):
	_player = player
	_enemies = enemies
	_closest_enemy = null
	_distance_to_closest_enemy = INF
	_cached = false
	
func get_closest_enemy() -> Node3D:
	if not _cached:
		_find_closest_enemy()
	return _closest_enemy

func get_distance_to_closest_enemy() -> float:
	if not _cached:
		_find_closest_enemy()
	return _distance_to_closest_enemy

func _find_closest_enemy():
	_cached = true
	for e in _enemies:
		var d = (e.position - _player.position).length()
		if d < _distance_to_closest_enemy:
			_distance_to_closest_enemy = d
			_closest_enemy = e

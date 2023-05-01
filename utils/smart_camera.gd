extends Camera3D

@export var time_to_catch_up: float = 0.3

var player: Player
var original_position: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
	original_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	var target_position = original_position
	target_position.x += player.position.x
	target_position.z += player.position.z
	
	var distance = (target_position - position).length()
	position = position.move_toward(target_position, min(distance * delta / time_to_catch_up, 0.2))

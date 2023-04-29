extends CharacterBody3D

@export var speed: float = 4 

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_position = player.position
	var diff_x = player_position.x - position.x
	var diff_y = player_position.z - position.z
	velocity = Vector3(diff_x, 0, diff_y).normalized() * speed
	rotation.y = atan2(diff_x, diff_y) + PI / 2

func _physics_process(delta):
	move_and_slide()

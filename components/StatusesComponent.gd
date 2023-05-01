extends Node
class_name StatusesComponent


@export var statuses: Array[Status]

func add_status(status: Status):
	statuses.append(status)

func get_speed() -> float:
	var result = 1.
	for s in statuses:
		if s.type == Status.StatusType.SPEED:
			result *= s.value
	return result

# Called when the node enters the scene tree for the first time.
func _ready():
	statuses = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

extends Node
class_name StatusesComponent

signal status_added(status: Status)

@export var health: HealthComponent
@export var statuses: Array[Status]

func add_status(status: Status):
	if status.type == Status.StatusType.VITALITY:
		health.add_vitality(status.value)
		
	status_added.emit(status)
	statuses.append(status)

func get_speed() -> float:
	var result = 1.
	for s in statuses:
		if s.type == Status.StatusType.SPEED:
			result *= s.value
	return result
	
func get_health_diff() -> float:
	var result = 0.
	for s in statuses:
		if s.type == Status.StatusType.FIRE:
			result += s.value
		if s.type == Status.StatusType.REGEN:
			result -= s.value
	return result

# Called when the node enters the scene tree for the first time.
func _ready():
	statuses = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if health != null:
		var health_diff = get_health_diff()
		health.take_damage(health_diff * delta)

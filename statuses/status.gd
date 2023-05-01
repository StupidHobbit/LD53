extends Resource
class_name Status

enum StatusType {SPEED, FIRE, REGEN, ICE} 

@export var type: StatusType
@export var value: float = 0

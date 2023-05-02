extends Resource
class_name Status

enum StatusType {SPEED, FIRE, REGEN, ICE, VITALITY} 

@export var type: StatusType
@export var value: float = 0

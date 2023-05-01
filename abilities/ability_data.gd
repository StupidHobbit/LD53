extends Resource

class_name AbilityData

@export var slug: String = ""
@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture
@export var projectile: ProjectileData
@export var cooldown: float = 1
@export var range: float = 10
@export var autocast: bool = true
@export var passive: bool = false
@export var statuses: Array[Status]

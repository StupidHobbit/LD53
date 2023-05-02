extends Projectile

@onready var damage_area = $DamageArea

# Called when the node enters the scene tree for the first time.
func _ready():
	if data == null:
		return
	var damage = data.damage
	data = ProjectileData.new()
	damage_area.damage = damage
	$DamageArea.statuses = statuses

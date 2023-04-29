extends Area3D


@export var health: HealthComponent

var parent 

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	area_entered.connect(_process_collision)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process_collision(o: Node3D):
	if o is Projectile:
		var projectile_stats: ProjectileData = o.get_stats() 
		health.take_damage(projectile_stats.damage)

func _process(delta):
	for o in get_overlapping_areas():
		if o is DamageArea:
			if o.is_on_cooldown():
				return
			health.take_damage(o.damage)
			o.damage_target(self)

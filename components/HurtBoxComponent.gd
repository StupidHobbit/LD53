extends Area3D


@export var health: HealthComponent
@export var statuses: StatusesComponent


var parent 

func _ready():
	parent = get_parent()
	area_entered.connect(_process_collision)

func _process_collision(o: Node3D):
	if o is Projectile:
		var projectile_stats: ProjectileData = o.get_stats() 
		health.take_damage(projectile_stats.damage)
		if statuses != null:
			for s in o.statuses:
				statuses.add_status(s)

func _process(delta):
	for o in get_overlapping_areas():
		if o is DamageArea:
			if o.is_on_cooldown():
				return
			health.take_damage(o.damage)
			o.damage_target(self)


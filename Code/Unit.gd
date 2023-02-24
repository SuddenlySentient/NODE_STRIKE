extends KinematicBody
class_name Unit

export(int) var max_health
onready var health = max_health

export(int) var armor

export(int) var max_fuel
onready var fuel = max_fuel

func get_random_destination(allowed_range):
	
	var new_destination = Vector3(get_translation())
	
	new_destination.x = int(rand_range(-allowed_range, allowed_range))
	new_destination.z = int(rand_range(-allowed_range, allowed_range))
	
	return new_destination

func take_damage(damage, piercing) :
	
	damage = float(damage)
	piercing = float(clamp(piercing, 1, INF))
	
	var damage_reduction = clamp((piercing / armor), 0, 1)
	
	damage = damage * damage_reduction
	
	health -= damage
	#print ("	",self," : owch! I took ",damage," damage! i now have ",health," health")
	
	if health <= 0 :
		die()

func die() :
	pass

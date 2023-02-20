extends KinematicBody
class_name Unit

export(int) var max_health
var health = max_health

export(int) var armor

export(int) var max_fuel
var fuel = max_fuel

func get_random_destination(allowed_range):
	
	var new_destination = Vector3(get_translation())
	
	new_destination.x = int(rand_range(-allowed_range, allowed_range))
	new_destination.z = int(rand_range(-allowed_range, allowed_range))
	
	return new_destination

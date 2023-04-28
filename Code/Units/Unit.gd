extends RigidBody3D
class_name Unit

@export var max_health: float
@onready var health = max_health
@export var armor: float = 1
@export var max_fuel: float
@onready var fuel = max_fuel
@export var max_supply: float
@onready var supply = max_supply
@export var roles: Array = ["Move", "Scout"]
@export var faction: String
@onready var explosion = preload("res://Visuals/Explosion/Explosion.tscn")
@onready var soundy = preload("res://Scene/soundy.tscn")
var action_queue = []

var movement_velocity = Vector3.ZERO

func move_to(_move_destination : Vector3, _satisfactory_distance : float) :
	pass

func move_to_object(_given_move_object : Object, _satisfactory_distance : float):
	pass

func move_to_nearest_target():
	pass

func unit_list() :
	return get_node("/root/Base/Units").get_children()

func enemy_list() :
	
	var new_enemy_list = []
	
	for x in unit_list() :
		if x.faction != faction :
			new_enemy_list.append(x)
	
	return new_enemy_list

func active_enemies() :
	if enemy_list().size() > 0 :
		return true
	else :
		return false

func get_closest_target() :
	
	var closest_enemy = enemy_list()[0]
	
	for x in enemy_list() :
		if closest_enemy.transform.origin.distance_to(transform.origin) > x.transform.origin.distance_to(transform.origin) :
			closest_enemy = x
	
	return closest_enemy

func get_random_destination(allowed_range : float):
	
	var new_destination = Vector3(get_position())
	
	new_destination.x = int(randf_range(-allowed_range, allowed_range))
	new_destination.z = int(randf_range(-allowed_range, allowed_range))
	
	return new_destination

func take_damage(given_damage : float, given_piercing : float) :
	
	given_piercing = max(given_piercing,1)
	
	var damage_reduction = min((given_piercing / armor), 1)
	
	given_damage = given_damage * damage_reduction
	
	health -= given_damage
	
	if health <= 0 :
		die()

func die() :
	
	var death_explosion = explosion.instantiate()
	
	get_node("/root/Base").add_child(death_explosion)
	
	death_explosion.transform.origin = transform.origin
	
	self.queue_free()

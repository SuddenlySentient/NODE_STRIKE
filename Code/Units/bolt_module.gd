extends Marker3D

@export var accuracy: float
@export var fire_rate: float
@export var damage: float
@export var piercing: float

var hits = 0.0
var misses = 0.0
var accuracy_percentage = 0.0
var attack_target
@onready var decal = preload("res://Scene/Bullet_Decal.tscn")
@onready var bolt = preload("res://Scene/Bolt.tscn")

@onready var shoot_timer = $"Timer"
@onready var fire_sound = $Fire
@onready var dry_sound = $"Dry Fire"
@onready var Base = $".."

func _enter_tree() :
	
	if fire_rate == 0 :
		fire_rate = 1
	
	fire_rate = 1 / fire_rate

func fire_bolt(raycast, barrel, no_hit) :
	
	var supply_cost = piercing/50
	
	if Base.supply >= supply_cost :
		
		fire_sound.pitch_scale = randf_range(0.75, 1.25)
		fire_sound.play(0)
		
		Base.supply -= supply_cost
		
		var inaccuracy = Vector2(randf_range(-accuracy, accuracy), randf_range(-accuracy, accuracy))
		
		raycast.target_position.y = inaccuracy.y
		raycast.target_position.x = inaccuracy.x
		
		raycast.force_raycast_update()
		
		var shot_bolt = bolt.instantiate()
		get_node("/root/Base").add_child(shot_bolt)
		
		if raycast.is_colliding() :
			
			var hit_target = raycast.get_collider()
			
			var bullet_decal = decal.instantiate()
			hit_target.add_child(bullet_decal)
			bullet_decal.global_transform.origin = raycast.get_collision_point()
			bullet_decal.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
			
			if hit_target.get_parent() == get_parent() :
				hits += 1
				hit_target.take_damage(damage, piercing)
			else :
				misses += 1
			
			shot_bolt.activate(barrel, raycast.get_collision_point())
		else :
			shot_bolt.activate(barrel, no_hit.global_transform.origin)
		return true
	else :
		
		dry_sound.pitch_scale = randf_range(0.75, 1.25)
		dry_sound.play(0)
		return false

func calculate_accuracy() :
	var total_shot = hits + misses
	
	if total_shot > 0 :
		accuracy_percentage = (hits / total_shot) * 100
		print (self," : I have fired with ",accuracy_percentage,"% accuracy")
	else :
		print (self," : I have not fired my gun yet, my accuracy can not determined")

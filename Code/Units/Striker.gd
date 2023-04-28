extends Driver

@onready var turret = $"Striker/Node2/Main/Turret"
@onready var barrel = $"Striker/Node2/Main/Turret/Barrel2"

@onready var muzzleFlash = $"Striker/Node2/Main/Turret/Barrel2/RayCast_Actual/MuzzleFlash"
@onready var raycast_actual = $"Striker/Node2/Main/Turret/Barrel2/RayCast_Actual"
@onready var raycast_ideal = $"Striker/Node2/Main/Turret/Barrel2/RayCast_ideal"
@onready var no_hit = $"Striker/Node2/Main/Turret/Barrel2/RayCast_Actual/No Hit"

var turret_rotation = 0
var barrel_rotation = 0
@export var turret_rotation_speed: float

@onready var Bolt = $"Bolt Module"

#	await get_tree().create_timer(3).timeout
#	attack_target = get_closest_target()
#	await drive_to_object(get_closest_target(), 1, 15)
#	while active_enemies() and get_closest_target().transform.origin.distance_to(transform.origin) < 30 :
#		await get_tree().create_timer( get_physics_process_delta_time() ).timeout
#	calculate_accuracy()

func _enter_tree():
	
	while 1 > 0 :
		while action_queue.size() > 0 :
			
			var action = action_queue[0]
			
			if action.command_type == "move" :
				await move_to(action.where, 5)
			
			action_queue.remove_at(0)
		
		await get_tree().create_timer(get_physics_process_delta_time()).timeout

func _process(_delta):
	
	if is_instance_valid(Bolt.attack_target) != true :
		Bolt.attack_target = null
	
	if Bolt.attack_target != null :
		
		rotate_turret()
		rotate_barrel()
		
		if pointing_at_target() and Bolt.shoot_timer.time_left == 0 :
			shoot_gun()

func rotate_turret():
	
	turret.look_at(Bolt.attack_target.transform.origin, Vector3.UP)
	
	var turret_ideal_rotation = clamp(turret.rotation_degrees.y, -120, 120)
	
	turret_rotation = (turret_ideal_rotation + (turret_rotation * (turret_rotation_speed - 1) )) / turret_rotation_speed
	
	turret.rotation_degrees = Vector3(0, turret_rotation, 0)

func rotate_barrel():
	
	barrel.look_at(Bolt.attack_target.transform.origin, Vector3.UP)
	
	var barrel_ideal_rotation = clamp(barrel.rotation_degrees.x, -2.5, 7.5)
	
	barrel_rotation = (barrel_ideal_rotation + (barrel_rotation * (turret_rotation_speed - 1) )) / turret_rotation_speed
	
	barrel.rotation_degrees = Vector3(barrel_rotation, 0, 0)

func shoot_gun():
	
	Bolt.shoot_timer.start(Bolt.fire_rate)
	
	if Bolt.fire_bolt(raycast_actual, barrel, no_hit) :
		
		muzzleFlash.rotation_degrees.x = randf_range(0, 359)
		muzzleFlash.show()
		
		await get_tree().create_timer(Bolt.fire_rate/2).timeout
		
		muzzleFlash.hide()

func pointing_at_target() :
	raycast_ideal.force_raycast_update()
	if raycast_ideal.get_collider() == Bolt.attack_target :
		return true
	else :
		return false

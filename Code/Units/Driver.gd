extends Unit
class_name Driver

@onready var agent : NavigationAgent3D = $Agent

@export var enginesoundstart : Resource
@export var enginesound : Resource
@export var enginesoundstop : Resource
@export var reversesound : Resource

@export var acceleration: int #lower values = faster forward
@export var reverse: int #lower values = faster reverse
@export var max_speed: int
@export var slip : int
var speed = 0
@export var look_speed : int
var engine_status = false

var ideal_direction = Vector3.FORWARD
var look_direction = Vector3.FORWARD
var move_direction = look_direction
var nearest_target_tracking = false
var object_tracking = false
var move_target

func move_to(move_destination : Vector3, satisfactory_distance : float):
	
	engine_status = true
	
	agent.set_target_position(move_destination) 
	
	while agent.is_navigation_finished() == false and transform.origin.distance_to(move_destination) > satisfactory_distance and engine_status == true :
		await get_tree().create_timer( get_physics_process_delta_time() ).timeout
	
	engine_status = false

func move_to_object(given_move_object : Object, satisfactory_distance : float):
	
	move_target = given_move_object
	
	engine_status = true
	object_tracking = true
	
	agent.set_target_position(move_target.transform.origin)
	
	while is_instance_valid(move_target) and transform.origin.distance_to(move_target.transform.origin) > satisfactory_distance and engine_status == true :
		
		await get_tree().create_timer( get_physics_process_delta_time() ).timeout
	
	engine_status = false
	object_tracking = false

func move_to_nearest_target():
	
	engine_status = true
	nearest_target_tracking = true
	
	agent.set_target_position(get_closest_target().transform.origin)
	
	while agent.is_navigation_finished() == false and engine_status == true :
		
		await get_tree().create_timer( get_physics_process_delta_time() ).timeout
	
	engine_status = false
	nearest_target_tracking = false

func _physics_process(delta):
	
	var fuel_cost = ( (abs(speed) * delta) / 600 )
	
	if engine_status and fuel >= fuel_cost:
		fuel -= fuel_cost
	else :
		engine_status = false
	
	if nearest_target_tracking == true and active_enemies() == true :
		agent.set_target_position(get_closest_target().transform.origin)
	
	if object_tracking == true and is_instance_valid(move_target) :
		agent.set_target_position(move_target.transform.origin)
	
	if engine_status == true :
		point_at(agent.get_next_path_position() - transform.origin)
	move(delta)

func point_at(direction: Vector3) :
	ideal_direction = direction.normalized()
	
	ideal_direction.y = 0
	
	look_direction = ((ideal_direction + (look_direction * (look_speed-1)) ) / look_speed).normalized()
	
	look_at(look_direction + transform.origin, Vector3.UP)

func move(delta) :
	
	linear_velocity.y = 0
	
	var lookness = look_direction.distance_to(ideal_direction)
	
	var speed_change = 1.0 - lookness
	
	if (speed_change > 0) :
		speed_change = speed_change/acceleration
	else :
		speed_change = speed_change/reverse
	
	speed += speed_change
	
	speed = clamp(speed,-max_speed, max_speed)
	
	if engine_status == false :
		speed = 0
	
		#movement_velocity and motion
	
	var motion = look_direction
	
	if engine_status == true:
		movement_velocity = ( motion * speed * delta + (movement_velocity * (slip-1) ))/ slip
	else :
		movement_velocity = ( movement_velocity * ( (slip * 1.5)-1 ) ) / (slip * 1.5)
	
		#move and bumper cars
	
		#test to see if a collsion will occur on move
	var collision = (move_and_collide(movement_velocity, true))
	
		#if collsion happens, bump self backwards, if the collider is a unit, bump it
	if collision != null :
		if collision.get_collider() is Unit :
			collision.get_collider().movement_velocity = movement_velocity
			movement_velocity = -movement_velocity / 2
		elif collision.get_collider() is RigidBody3D :
			collision.get_collider().linear_velocity = movement_velocity * (mass / collision.get_collider().mass)
			movement_velocity = -movement_velocity / 2
		else :
			movement_velocity = -movement_velocity / 2
		speed = 0
	
	move_and_collide(movement_velocity)

func set_engine(startstop : bool):
	if (startstop):
		var engine_start = soundy.instantiate()
		engine_start.play_sound(enginesoundstart)
		engine_status = true
	else :
		var engine_stop = soundy.instantiate()
		engine_stop.play_sound(enginesoundstop)
		engine_status = false

extends Unit
class_name Hover

@export var flight_cost: float
@export var max_fly_speed: float
var fly_speed = 0
@export var fly_height_offset: float
@export var max_fly_height: float
@export var slip : int
@export var acceleration : int
var engine_status = false
var lift_off = false
var active = false
var move_target

func move_to(target_location, satisfactory_distance):
	
	move_target = target_location
	
	engine_status = true
	active = true
	
	var distance_ignore_y = Vector2(transform.origin.x, transform.origin.z).distance_to(Vector2(move_target.x, move_target.z))
	
	while distance_ignore_y > satisfactory_distance and engine_status == true :
		distance_ignore_y = Vector2(transform.origin.x, transform.origin.z).distance_to(Vector2(move_target.x, move_target.z))
		await get_tree().create_timer( get_physics_process_delta_time() ).timeout
	
	active = false

func _physics_process(delta):
	
	var fuel_cost = (flight_cost * delta) / 600
	
	if fuel >= fuel_cost and engine_status :
		fuel -= fuel_cost
	else :
		engine_status = false
	
	move(delta)
	animate(movement_velocity, fly_speed)

func move(delta) :
	
	var pre_move_velocity = movement_velocity
	
	if engine_status :
		
		linear_velocity.y = 0
		
		if active :
			fly_speed += acceleration * delta
		else :
			fly_speed -= acceleration * delta
		
		fly_speed = clamp(fly_speed, 0, max_fly_speed)
		
		var ideal_move
		
		if lift_off :
			ideal_move = move_target
			ideal_move.y = min(move_target.y + fly_height_offset, max_fly_height)
		else :
			ideal_move = transform.origin
			ideal_move.y = min(move_target.y + fly_height_offset, max_fly_height)
		
		if ideal_move.y - transform.origin.y > ideal_move.y / 5:
			lift_off = true
		
		if active :
			movement_velocity = Vector3.ZERO.move_toward(ideal_move - transform.origin, fly_speed * delta)
		else :
			movement_velocity = pre_move_velocity.move_toward(Vector3.ZERO, fly_speed * delta)
		
		movement_velocity = (movement_velocity + (pre_move_velocity * (slip - 1))) / slip
		
	else :
		movement_velocity = (Vector3.ZERO + (pre_move_velocity * (slip - 1))) / slip
		fly_speed = 0
		lift_off = false
	
	move_and_collide(movement_velocity)

func animate(_velocity : Vector3, _speed : float) :
	pass

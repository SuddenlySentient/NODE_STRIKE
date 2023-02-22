extends Unit
class_name Driver
onready var agent : NavigationAgent = $Agent

export(int) var acceleration #lower values = faster forward
export(int) var reverse #lower values = faster reverse
export(int) var max_speed
var speed = 0
export(int)var slip
export(int)var look_speed
var velocity = Vector3.ZERO
var engine_status = false

var ideal_direction = Vector3.FORWARD
var look_direction = Vector3.FORWARD
var move_direction = look_direction

var target_transform = Vector3.ZERO
var target_object
var target_tracking = false

func _ready():
	agent.set_target_location(Vector3.ZERO)

func drive_to(move_destination, distance):
	yield(get_tree(), "idle_frame")
	
	agent.set_path_desired_distance(distance) 
	
	print(self," : Starting Engines")
	
	engine_status = true
	
	agent.set_target_location(move_destination)
	
	target_transform = move_destination
	
	target_tracking = false
	
	while agent.is_navigation_finished() == false :
		
		yield(get_tree().create_timer(0.1), "timeout")
	
	engine_status = false
	
	print(self," : All Done!")

func drive_to_object(move_object, distance):
	yield(get_tree(), "idle_frame")
	
	agent.set_path_desired_distance(distance) 
	
	print(self," : Aproaching Target")
	
	engine_status = true
	
	target_object = move_object
	
	target_transform = target_object.transform.origin
	
	agent.set_target_location(target_transform)
	
	target_tracking = true
	
	while agent.is_navigation_finished() == false :
		
		yield(get_tree().create_timer(0.1), "timeout")
		
		target_transform = target_object.transform.origin
	
	engine_status = false
	
	print(self," : Target Reached!")

func _physics_process(_delta):
	
	if target_tracking == true :
		target_transform = target_object.transform.origin
	
	if engine_status == true :
		point_at()
	move()

func point_at() :
	agent.set_target_location(target_transform)
	
	ideal_direction = (agent.get_next_location() - transform.origin).normalized()
	
	ideal_direction.y = 0
	
	look_direction = ((ideal_direction + (look_direction * (look_speed-1)) ) / look_speed).normalized()
	
	look_at(look_direction + transform.origin, Vector3.UP)

func move() :
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
	
		#velocity and motion
	
	var motion = look_direction
	
	if engine_status == true :
		velocity =  ( (motion * speed) + ( velocity * (slip-2) ) ) / slip
	else :
		velocity = ( Vector3.ZERO + ( velocity * (slip-1) ) ) / slip
	
		#move (delta already accounted for with move_and_slide)
	
	velocity = move_and_slide(velocity)

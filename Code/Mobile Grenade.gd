extends Driver

onready var wheel = $"Mobile Grenade/Node2/Main/Wheel"

var last_frame = Vector2(transform.origin.x,transform.origin.z)

func _ready():
	
	var move_distance = 100
	
	var target
	
	yield(get_tree().create_timer(3), "timeout")
	
	while 1 > 0 :
		
		target = get_random_destination(move_distance)
		
		yield(drive_to(target, 5), "completed")
		
		yield(get_tree().create_timer(3), "timeout")

func _process(_delta):
	
	var this_frame = Vector2(transform.origin.x,transform.origin.z)
	
	var move_distance = this_frame.distance_to(last_frame)
	
	if speed >= 0 :
		wheel.rotate_x(-move_distance)
	else :
		wheel.rotate_x(move_distance)
	
	last_frame = this_frame

extends Camera

onready var target1 = $"../Rover"
#onready var target1 = $"../Striker"
onready var target2 = $"../Striker"

export(float) var softness
export(float) var minDistance
export(float) var maxDistance

var camera_spot = transform.origin
var ideal_camera_spot

func _process(_delta):
	
	ideal_camera_spot = (target1.transform.origin + target2.transform.origin) / 2
	
	var distance = target1.transform.origin.distance_to(target2.transform.origin)
	
	distance = clamp(distance, minDistance, maxDistance)
	
	ideal_camera_spot.y += distance
	ideal_camera_spot.z += -distance
	
	camera_spot = (camera_spot * (softness-1) + ideal_camera_spot) / softness
	
	set_translation(camera_spot)
	
	#look_at(camera_spot, Vector3.UP)
	

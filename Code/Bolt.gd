extends Node3D

var bolt_length

var activated = false

var start_point
var end_point

func activate(object_start_point, given_end_point):
	
	start_point = object_start_point
	end_point = given_end_point
	
		#start point is an object and end point is an Vector3 !!!
	
	activated = true

func _enter_tree():
	
	hide()
	
	await get_tree().create_timer(0.075).timeout
	
	self.queue_free()

func _process(_delta):
	
	if activated and is_instance_valid(start_point) :
		
		var distance = start_point.global_transform.origin.distance_to(end_point)
		
		$MeshInstance3D.scale.y = distance
		
		$MeshInstance2.transform.origin.z = distance/2
		
		global_transform.origin = (start_point.global_transform.origin + end_point) / 2
		
		look_at(start_point.global_transform.origin, Vector3.UP)
		
		show()

extends Spatial

var bolt_length

var activated = false

var start_point
var end_point

var default_material = preload("res://Visuals/Laser.tres")

var material = default_material

func activate(object_start_point, given_end_point):
	
	start_point = object_start_point
	end_point = given_end_point
	
		#start point is an object and end point is an Vector3 !!!
	
	activated = true


func _enter_tree():
	
	for x in 5 :
		yield(get_tree().create_timer(0.05), "timeout")
		
		print(material.albedo_color.a)
		
		material.albedo_color.a -= 0.2
		
		$MeshInstance.set_surface_material(0, material)
	
	#self.queue_free()

func _process(_delta):
	if activated :
		
		var distance = start_point.global_transform.origin.distance_to(end_point)
		
		$MeshInstance.scale.y = distance
		
		$MeshInstance2.transform.origin.z = distance/2
		
		global_transform.origin = (start_point.global_transform.origin + end_point) / 2
		
		look_at(start_point.global_transform.origin, Vector3.UP)
	else :
		hide()

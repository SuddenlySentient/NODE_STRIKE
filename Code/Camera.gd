extends Camera3D

@export var move_margin: int
@export var move_speed: float
@export var scroll_speed: float

func _process(delta):
	margin_move(delta)

func margin_move(delta) :
	var motion = Vector3()
	var viewport_size = get_viewport_size()
	var mouse_pos = mouse_position_getter()
	
	motion.x += ( min(-move_margin + mouse_pos.x, 0) ) + ( -1 * min((viewport_size.x - move_margin) - mouse_pos.x, 0) )
	
	motion.z += ( min(-move_margin + mouse_pos.y, 0) ) + ( -1 * min((viewport_size.y - move_margin) - mouse_pos.y, 0) )
	
	motion = motion.rotated(Vector3.UP, rotation_degrees.y)
	global_translate(motion * delta * move_speed)

func _input(event) :
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_WHEEL_UP :
			transform.origin.y = transform.origin.y * scroll_speed
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN :
			transform.origin.y = transform.origin.y / scroll_speed

func raycast_from_mouse() :
	var mouse_pos = mouse_position_getter()
	var ray_start = self.project_ray_origin(mouse_pos)
	var ray_end = ray_start + self.project_ray_normal(mouse_pos) * 1000
	var space_state = get_world_3d().direct_space_state
	
	var ray_intersect_point = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_start, ray_end))
	
	#$"../Testo".transform.origin = ray_intersect_point.position
	
	return ray_intersect_point

func get_viewport_size() :
	return get_viewport().size

func mouse_position_getter() :
	var viewport_size = get_viewport_size()
	var mouse_pos = get_viewport().get_mouse_position()
	mouse_pos.x = clamp(mouse_pos.x, 0, viewport_size.x)
	mouse_pos.y = clamp(mouse_pos.y, 0, viewport_size.y)
	return mouse_pos

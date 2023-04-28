extends Marker3D

@onready var Base = $".."

var statis_targets = []
@export var statis_softness: float
@export var statis_forgivness: float
@export var statis_limit: int
@export var statis_y_offset: float

func grab(grab_target):
	
	await Base.move_to_object(grab_target, 2.5)
	
	grab_target.picked_up = true
	
	statis_targets.append(grab_target)

func put_down(put_down_target):
	
	put_down_target.picked_up = true
	
	statis_targets.erase(put_down_target)

func _physics_process(delta):
	
	var supply_cost = (0.0166666666666667 * statis_targets.size() * statis_targets.size()) * delta
	
	if Base.supply >= supply_cost :
		
		Base.supply -= supply_cost
		
		var next_in_line = Base
		
		if statis_targets.size() > 0 :
			if $statis_loop.playing == false :
				$statis_loop.play()
		else :
			$statis_loop.stop()
		
		for statis_target in statis_targets :
			var ideal_pos = Vector3()
			
			ideal_pos.x = clamp(statis_target.transform.origin.x, next_in_line.transform.origin.x -statis_forgivness, next_in_line.transform.origin.x +statis_forgivness)
			ideal_pos.y = transform.origin.y + statis_y_offset
			ideal_pos.z = clamp(statis_target.transform.origin.z, next_in_line.transform.origin.z -statis_forgivness, next_in_line.transform.origin.z +statis_forgivness)
			
			statis_target.transform.origin.x = ( ideal_pos.x + (statis_target.transform.origin.x * (statis_softness-1) ) ) / statis_softness
			statis_target.transform.origin.y = ( ideal_pos.y + (statis_target.transform.origin.y * (statis_softness-1) ) ) / statis_softness
			statis_target.transform.origin.z = ( ideal_pos.z + (statis_target.transform.origin.z * (statis_softness-1) ) ) / statis_softness
			statis_target.linear_velocity.y = 0
			
			next_in_line = statis_target
	else :
		statis_targets.clear()

extends Driver

onready var model = $"Armored Carrier/AnimationPlayer"

func _ready():
	
	var move_distance = 100
	
	var target
	
	yield(get_tree().create_timer(3), "timeout")
	
	while 1 > 0 :
		
		target = get_random_destination(move_distance)
		
		yield(drive_to(target, 5), "completed")
		
		yield(get_tree().create_timer(3), "timeout")

func _process(_delta):
	
	#$"../MeshInstance".transform.origin = agent.get_next_location()
	
	if (engine_status == true) :
		
		model.play("Track Move")

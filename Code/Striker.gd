extends Driver

onready var rover = $"../Rover"

onready var turret = $"Striker/Node2/Main/Turret"
onready var barrel = $"Striker/Node2/Main/Turret/Barrel2"

onready var target = rover 

var turret_rotation

var pointing

func _ready():
	
	yield(get_tree().create_timer(3), "timeout")
	
	
	while 1 > 0 :
		
		yield(drive_to_object(target, 5), "completed")
		
		yield(get_tree().create_timer(3), "timeout")

func _process(_delta):
	
	rotate_turret()

func rotate_turret():
	
	turret.look_at(target.transform.origin, Vector3.UP)
	
	var turret_ideal_rotation = turret.rotation_degrees.y
	
	var turret_rotation =  clamp(turret_ideal_rotation, -120, 120)
	
	if turret_ideal_rotation == turret_rotation :
		pointing = true
	else :
		pointing = false
	
	turret.rotation_degrees = Vector3(0, turret_rotation, 0)

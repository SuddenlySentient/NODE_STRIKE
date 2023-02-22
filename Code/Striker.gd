extends Driver

onready var turret = $"Striker/Node2/Main/Turret"
onready var barrel = $"Striker/Node2/Main/Turret/Barrel2"

onready var muzzleFlash = $"Striker/Node2/Main/Turret/Barrel2/RayCast_Actual/MuzzleFlash"
onready var timer = $"Striker/Node2/Main/Turret/Barrel2/Timer"
onready var sound = $"Striker/Node2/Main/Turret/Barrel2/AudioStreamPlayer3D"
onready var raycast_actual = $"Striker/Node2/Main/Turret/Barrel2/RayCast_Actual"
onready var raycast_ideal = $"Striker/Node2/Main/Turret/Barrel2/RayCast_ideal"

onready var rover = $"../Rover"
onready var target = rover 

var pointing
var turret_rotation = 0

export(float) var turret_rotation_speed
export(float) var shoot_speed
export(float) var accuracy

func _ready():
	
	timer.one_shot = true
	
	yield(get_tree().create_timer(3), "timeout")
	
	while 1 > 0 :
		
		yield(drive_to_object(target, 5), "completed")
		
		yield(get_tree().create_timer(3), "timeout")

func _process(_delta):
	
	rotate_turret()
	
	if pointing == true and timer.time_left == 0:
		fire_gun(0, 0)
		timer.start(shoot_speed)

func rotate_turret():
	
	turret.look_at(target.transform.origin, Vector3.UP)
	
	var turret_ideal_rotation = clamp(turret.rotation_degrees.y, -120, 120)
	
	turret_rotation = (turret_ideal_rotation + (turret_rotation * (turret_rotation_speed - 1) )) / turret_rotation_speed
	
	raycast_ideal.force_raycast_update()
	if raycast_ideal.get_collider() == target :
		pointing = true
	else :
		pointing = false
	
	turret.rotation_degrees = Vector3(0, turret_rotation, 0)

func fire_gun(damage, piercing):
	
	var inaccuracy = Vector2(rand_range(-accuracy, accuracy),rand_range(-accuracy, accuracy)).normalized()
	raycast_actual.rotation_degrees.x = inaccuracy.x
	raycast_actual.rotation_degrees.y = inaccuracy.y
	
	muzzleFlash.rotation_degrees.x = rand_range(0, 359)
	muzzleFlash.show()
	
	sound.pitch_scale = rand_range(0.9, 1.1)
	sound.play(0)
	
	raycast_actual.force_raycast_update()
	
	if raycast_actual.is_colliding():
		var hit_target = raycast_actual.get_collider()
	
	yield(get_tree().create_timer(0.25), "timeout")
	muzzleFlash.hide()

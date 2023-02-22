extends Driver

onready var turret = $"Striker/Node2/Main/Turret"
onready var barrel = $"Striker/Node2/Main/Turret/Barrel2"

onready var muzzleFlash = $"Striker/Node2/Main/Turret/Barrel2/RayCast_Actual/MuzzleFlash"
onready var sound = $"Striker/Node2/Main/Turret/Barrel2/AudioStreamPlayer3D"
onready var raycast_actual = $"Striker/Node2/Main/Turret/Barrel2/RayCast_Actual"
onready var raycast_ideal = $"Striker/Node2/Main/Turret/Barrel2/RayCast_ideal"
onready var decal = preload("res://Scene/Bullet_Decal.tscn")
onready var shoot_timer = $"Striker/Node2/Main/Turret/Barrel2/Timer"

onready var rover = $"../Rover"
onready var target = rover 

var pointing
var turret_rotation = 0

export(float) var turret_rotation_speed
export(float) var shoot_speed
export(float) var accuracy

func _ready():
	
	yield(get_tree().create_timer(3), "timeout")
	
	while 1 > 0 :
		
		yield(drive_to_object(target, 5), "completed")
		
		yield(get_tree().create_timer(3), "timeout")

func _process(_delta):
	
	rotate_turret()
	
	if pointing == true and shoot_timer.time_left == 0 :
		shoot_timer.start(shoot_speed)
		fire_gun(0, 0)

func rotate_turret():
	
	turret.look_at(target.transform.origin, Vector3.UP)
	
	var turret_ideal_rotation = clamp(turret.rotation_degrees.y, -120, 120)
	
	turret_rotation = (turret_ideal_rotation + (turret_rotation * (turret_rotation_speed - 1) )) / turret_rotation_speed
	
	turret.rotation_degrees = Vector3(0, turret_rotation, 0)
	
	raycast_ideal.force_raycast_update()
	if raycast_ideal.get_collider() == target :
		pointing = true
	else :
		pointing = false

func fire_gun(damage, piercing):
	
	muzzleFlash.rotation_degrees.x = rand_range(0, 359)
	muzzleFlash.show()
	
	sound.pitch_scale = rand_range(0.9, 1.1)
	sound.play(0)
	
	var inaccuracy = Vector2(rand_range(-accuracy, accuracy),rand_range(-accuracy, accuracy)).normalized()
	raycast_actual.rotation_degrees.x = inaccuracy.x
	raycast_actual.rotation_degrees.y = inaccuracy.y
	
	raycast_actual.force_raycast_update()
	
	if raycast_actual.get_collider() != null :
		var bullet_decal = decal.instance()
		raycast_actual.get_collider().add_child(bullet_decal)
		bullet_decal.global_transform.origin = raycast_actual.get_collision_point()
		bullet_decal.look_at(raycast_actual.get_collision_point() + raycast_actual.get_collision_normal(), Vector3.UP)
	
	yield(get_tree().create_timer(0.25), "timeout")
	muzzleFlash.hide()

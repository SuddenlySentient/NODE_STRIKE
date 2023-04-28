extends StaticBody3D
class_name Building

var supply: float
var fuel: float

@export var faction: String

@export var supply_consume: float
@export var fuel_consume: float
@export var produce: Resource
@export var production_cost: float
@export var production_time: float

var produced_total = 0
@export var produce_name: String
@export var building_tag: StringName


func produce_resource(production_sound, finish_sound, production_timer) :
	if supply >= supply_consume and fuel >= fuel_consume :
		supply -= supply_consume
		fuel -= fuel_consume
	
	production_sound.play(0.0)
	production_timer.start(production_time)
	await production_timer.timeout
	production_sound.stop()
	finish_sound.play(0.0)
	
	var produced_good = produce.instantiate()
	
	var numb = ""
	for x in 4 - var_to_str(produced_total).length() :
		numb += "0"
	produced_good.name = produce_name + "-" + building_tag + "-" + numb + var_to_str(produced_total)
	produced_total += 1
	get_node("/root/Base").add_child(produced_good)
	
	produced_good.transform.origin = transform.origin + (Vector3(0, 1, 2).rotated(Vector3.UP, rotation.y))
	produced_good.linear_velocity = Vector3(0, 1, 5).rotated(Vector3.UP, rotation.y)
	produced_good.angular_velocity = Vector3(-1, 0, 0).rotated(Vector3.UP, rotation.y)

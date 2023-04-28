extends Control

@onready var camera = $"../Camera3D"
@onready var red_box_text = $"Red Box/RedBox/Red Box Text"
@onready var switch = $"VBoxContainer/Panel/Box/HBoxContainer/Switch"
@onready var green_box_right_text = $"VBoxContainer/Green Box/GreenBox/Green Box Text2"
var selection_target
var selector
@onready var new_selector = preload("res://Scene/unit_selection.tscn")

func _ready():
	selector = new_selector.instantiate()
	get_node("/root/Base").add_child.call_deferred(selector)

func _process(_delta):
	
	red_box()
	green_box()

func _input(_event) :
	
	var raycasted = camera.raycast_from_mouse()
	
	if raycasted.is_empty() == false :
		
		if Input.is_action_just_pressed("mouse_1") and selection_target != raycasted.collider :
			
			print (raycasted.collider)
			
			selection_target = raycasted.collider
			selector.target = selection_target
			red_box_text.visible_characters = 0
			green_box_right_text.visible_characters = 0
			
			if selection_target is Unit :
				selector.mode = "select"
			else :
				selector.mode = "none"
		
		if Input.is_action_just_pressed("mouse_2") :
			
			if selection_target is Unit :
				
				selector.mode = "select"
				
				if selection_target.roles.find("Logi") != -1 and raycasted.collider is Item :
					var logi_command = {
					"command_type":"logi",
					"what":raycasted.collider
					}
					selection_target.action_queue.append(logi_command) 
				
				elif selection_target.roles.find("Attack") != -1 and raycasted.collider is Unit and selection_target.faction != raycasted.collider.faction :
					pass
				
				elif selection_target.roles.find("Move") != -1 :
					var move_command = {
					"command_type":"move",
					"where":raycasted.position,
					}
					selection_target.action_queue.append(move_command) 
	
	
	
	while red_box_text.visible_characters < red_box_text.text.length() :
		await get_tree().create_timer(0.05).timeout
		red_box_text.visible_characters += 1
	while green_box_right_text.visible_characters < green_box_right_text.text.length() :
		await get_tree().create_timer(0.05).timeout
		green_box_right_text.visible_characters += 1

func unit_info_string(info_target : Unit) :
	
	var unit_info = ""
	
	unit_info += info_target.name
	unit_info += "
"
	unit_info += info_target.faction
	unit_info += "
"
	unit_info += "------------"
	unit_info += "
"
	unit_info += "hp   |"+var_to_str(int(info_target.max_health)) + "/" + var_to_str(int(round(info_target.health)))
	unit_info += "
"
	unit_info += "armor|"+var_to_str(info_target.armor)
	unit_info += "
"
	unit_info += "fuel |"+var_to_str(int(info_target.max_fuel)) + "/" + var_to_str(int(round(info_target.fuel)))
	unit_info += "
"
	if info_target.roles.find("Attack") != -1 :
		var bolt_module = info_target.Bolt
		unit_info += "dmg  |"+var_to_str(bolt_module.damage)
		unit_info += "
"
		unit_info += "AP   |"+var_to_str(bolt_module.piercing)
		unit_info += "
"
		unit_info += "FR   |"+var_to_str(1/bolt_module.fire_rate)
		unit_info += "
"
	unit_info += "suply|"+var_to_str(int(info_target.max_supply)) + "/" + var_to_str(int(round(info_target.supply)))
	
	return unit_info

func building_info_string(info_target : Building) :
	
	var building_info = ""
	
	building_info += info_target.name
	building_info += "
"
	building_info += info_target.faction
	building_info += "
"
	building_info += "------------"
	building_info += "
"
	
	var meter_max = info_target.production_time
	var meter = (info_target.production_timer.time_left / meter_max) * 10
	var meterstr = "<"
	
	for x in int(ceil(10 - meter)) :
		meterstr += "|"
	
	for x in int(meter) :
		meterstr += " "
	
	meterstr += ">"
	building_info += meterstr
	building_info += "
"
	building_info += "scost|"+var_to_str(info_target.supply_consume)
	building_info += "
"
	building_info += "Fcost|"+var_to_str(info_target.fuel_consume)
	building_info += "
"
	building_info += "fuel |"+ var_to_str(info_target.fuel)
	building_info += "
"
	building_info += "suply|"+ var_to_str(info_target.supply)
	
	return building_info

func red_box() :
	if is_instance_valid(selection_target) == false :
		selection_target = null
	
	if selection_target is Unit :
		red_box_text.text = unit_info_string(selection_target)
	
	elif  selection_target is Building :
		red_box_text.text = building_info_string(selection_target)
	
	else :
		red_box_text.text = "INVALID
		TARGET
		SELECTED"

func green_box() :
	if switch.toggle_state:
		if selection_target is Unit :
			green_box_right_text.text = action_queue_info_string(selection_target)
		
		elif selection_target != null :
			green_box_right_text.text = selection_target.name
		
		else :
			green_box_right_text.text = "NO TARGET SELECTED"

func action_queue_info_string(info_target : Unit) :
	
	var action_queue_info = "action queue : " + var_to_str(info_target.action_queue.size())
	action_queue_info += "
"
	for action in info_target.action_queue :
		action_queue_info += action.command_type
		action_queue_info += "
"
		if action.has("where") :
			action_queue_info += " " + var_to_str(int(action.where.x)) + "," + var_to_str(int(action.where.y)) + "," + var_to_str(int(action.where.z))
			action_queue_info += "
"
		if action.has("what") :
			action_queue_info += " " + action.what.name
			action_queue_info += "
"
	return action_queue_info

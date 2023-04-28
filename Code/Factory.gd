extends Building

@onready var production_sound = $"Production Sound"
@onready var finish_sound = $"Finish Sound"
@onready var production_timer = $"Production Timer"


func _enter_tree() :

	await get_tree().create_timer(1).timeout
	
	name = "Factory" + "-" + building_tag
	
	while 1 > 0 :
		await produce_resource(production_sound, finish_sound, production_timer)

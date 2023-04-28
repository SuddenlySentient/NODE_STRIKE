extends Driver

@onready var Logistic = $"Logistic Module"

func _enter_tree():
	
	while 1 > 0 :
		while action_queue.size() > 0 :
			
			var action = action_queue[0]
			
			if action.command_type == "move" :
				await move_to(action.where, 5)
			
			elif action.command_type == "logi" :
				if Logistic.statis_targets.find(action.what) == -1 :
					await Logistic.grab(action.what)
				else :
					Logistic.put_down(action.what)
			action_queue.remove_at(0) 
		
		await get_tree().create_timer(get_physics_process_delta_time()).timeout

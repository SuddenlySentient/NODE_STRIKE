extends AudioStreamPlayer3D

var loop : bool

func play_sound(sound : Resource):
	stream = sound
	play(0)
	
	while playing :
		await get_tree().create_timer( get_physics_process_delta_time() ).timeout
	stop_playing()

func stop_playing():
	self.queue_free()

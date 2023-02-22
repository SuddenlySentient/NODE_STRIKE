extends Spatial

func _enter_tree():
	
	yield(get_tree().create_timer(150), "timeout")
	
	self.queue_free()

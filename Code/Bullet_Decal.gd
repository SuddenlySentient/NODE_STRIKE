extends Node3D

func _enter_tree():
	
	await get_tree().create_timer(150).timeout
	
	self.queue_free()

extends Node3D



func _enter_tree():
	
	var sprite = $Sprite3D
	
	for x in 19 :
		await get_tree().create_timer(0.05).timeout
		sprite.frame += 1
	
	self.queue_free()

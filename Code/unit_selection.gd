extends Node3D

var mode
var spin = 0
@export var spin_rate: float
var target = self

func _physics_process(delta) :
	
	transform.origin = target.transform.origin
	
	$"Unit Select".hide()
	$"Unit Attack".hide()
	$"Unit Support".hide()
	
	if mode == "select" :
		$"Unit Select".show()
	
	elif mode == "attack" :
		$"Unit Attack".show()
	
	elif mode == "support" :
		$"Unit Support".show()
	
	rotation_degrees.y = spin
	spin += spin_rate * delta
	if spin >= 360 :
		spin -= 360

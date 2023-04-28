extends TextureButton

var sounds = [
	load("res://Sounds/LBP/ticking_clock_2_01.wav"),
	load("res://Sounds/LBP/ticking_clock_2_02.wav")]

var toggle_state = false

func _on_toggled(button_pressed):
	toggle_state = button_pressed
	$AudioStreamPlayer.stream = sounds.pick_random()
	$AudioStreamPlayer.pitch_scale = randf_range(0.75, 1.25)
	$AudioStreamPlayer.play(0)

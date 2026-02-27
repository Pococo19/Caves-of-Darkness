extends Control

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://levels/testlevel2.tscn")

func _on_options_button_pressed():
	print("Options menu not yet implemented")

func _on_quit_button_pressed():
	get_tree().quit()

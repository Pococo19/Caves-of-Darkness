extends Control

@onready var main_container = $VBoxContainer
@onready var options_container = $OptionsContainer
@onready var master_slider = $OptionsContainer/MasterSlider
@onready var music_slider = $OptionsContainer/MusicSlider
@onready var sfx_slider = $OptionsContainer/SFXSlider

func _ready():
	# Load saved volumes
	master_slider.value = AudioServer.get_bus_volume_db(0)
	if AudioServer.get_bus_index("Music") != -1:
		music_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	if AudioServer.get_bus_index("SFX") != -1:
		sfx_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://levels/testlevel2.tscn")

func _on_options_button_pressed():
	main_container.visible = false
	options_container.visible = true

func _on_quit_button_pressed():
	get_tree().quit()

func _on_back_button_pressed():
	options_container.visible = false
	main_container.visible = true

func _on_master_slider_value_changed(value: float):
	AudioServer.set_bus_volume_db(0, value)

func _on_music_slider_value_changed(value: float):
	var bus_index = AudioServer.get_bus_index("Music")
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, value)

func _on_sfx_slider_value_changed(value: float):
	var bus_index = AudioServer.get_bus_index("SFX")
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, value)

extends Control

@export var apply_btn: Button

@onready var fullscreen_btn: CheckButton = %CheckButton

@onready var master_slider: HSlider = %MasterSlider
@onready var master_percent: Label = %MasterPercent

@onready var music_slider: HSlider = %MusicSlider
@onready var music_percent: Label = %MusicPercent

@onready var sfx_slider: HSlider = %SFXSlider
@onready var sfx_percent: Label = %SFXPercent

func _on_apply_button_down() -> void:
	visible = false

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_master_slider_value_changed(value: float) -> void:
	master_percent.text = str(int(value*100)) + "%"
	
	var audio = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(audio, linear_to_db(value))

func _on_music_slider_value_changed(value: float) -> void:
	music_percent.text = str(int(value*100)) + "%"
	
	var audio = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(audio, linear_to_db(value))

func _on_sfx_slider_value_changed(value: float) -> void:
	sfx_percent.text = str(int(value*100)) + "%"
	
	var audio = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(audio, linear_to_db(value))

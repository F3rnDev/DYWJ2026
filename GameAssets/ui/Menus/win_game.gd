extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_restart_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_main_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://GameAssets/ui/Menus/main_menu.tscn")

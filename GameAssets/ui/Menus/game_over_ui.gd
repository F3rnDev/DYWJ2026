extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("on_effect_game_over")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	$Audio/Enter.play()

func _on_restart_button_down() -> void:
	$Audio/ClickMenu.play()
	animation_player.play("off_effect_game_over")

func _on_main_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://GameAssets/ui/Menus/main_menu.tscn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "off_effect_game_over":
		get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_mouse_entered() -> void:
	$Audio/HoverMenu.play()

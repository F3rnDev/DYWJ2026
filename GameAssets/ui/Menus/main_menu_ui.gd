extends CanvasLayer

@export var play: Button
@export var settings: Button
@export var quit: Button
@export var settings_menu: Control

@export var tween_trans: Tween.TransitionType
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if OS.get_name() == "Web":
		quit.queue_free()
	settings_menu.visible = false
	

func _on_play_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(play, "size", Vector2(350.0, 0.0), .1).set_trans(tween_trans)

func _on_play_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(play, "size", Vector2(300.0, 0.0), .1).set_trans(tween_trans)

func _on_settings_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(settings, "size", Vector2(350.0, 0.0), .1).set_trans(tween_trans)

func _on_settings_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(settings, "size", Vector2(300.0, 0.0), .1).set_trans(tween_trans)

func _on_quit_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(quit, "size", Vector2(350.0, 0.0), .1).set_trans(tween_trans)

func _on_quit_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(quit, "size", Vector2(300.0, 0.0), .1).set_trans(tween_trans)

func _on_settings_button_down() -> void:
	settings_menu.visible = true
	settings_menu.animation_player.play("on_effect")

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_play_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

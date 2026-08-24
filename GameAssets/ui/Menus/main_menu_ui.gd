extends CanvasLayer

@export var play: Button
@export var settings: Button
@export var quit: Button
@export var settings_menu: Control

@export var tween_trans: Tween.TransitionType
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var goToTutorial = false

func _ready() -> void:
	if OS.get_name() == "Web":
		quit.queue_free()
	settings_menu.visible = false
	animation_player.play("core")

func _on_mouse_entered() -> void:
	$Audio/HoverMenu.play()

func _on_button_down():
	$Audio/ClickMenu.play()

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

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_play_button_down() -> void:
	if GlobalVar.playedTutorial:
		animation_player.play("fade_out")
	else:
		$popup.visible = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "fade_out":
		return
	
	if !goToTutorial:
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")

func _on_yes_button_down() -> void:
	goToTutorial = true
	animation_player.play("fade_out")

func _on_no_button_down() -> void:
	animation_player.play("fade_out")

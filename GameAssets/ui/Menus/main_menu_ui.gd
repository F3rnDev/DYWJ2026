extends CanvasLayer

@export var play: Button
@export var settings: Button
@export var quit: Button

@export var tween_trans: Tween.TransitionType

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

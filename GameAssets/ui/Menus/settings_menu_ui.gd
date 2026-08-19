extends Control

@export var apply_btn: Button
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_apply_button_down() -> void:
	animation_player.play("off_effect")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "off_effect":
		visible = false

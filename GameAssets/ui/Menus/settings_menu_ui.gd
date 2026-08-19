extends Control

@export var apply_btn: Button
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	if visible == true:
		animation_player.play("on_effect")

func _on_apply_button_down() -> void:
	visible = false

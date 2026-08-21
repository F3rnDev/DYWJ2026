extends Control

@onready var buy_batery: Button = %BuyBatery
@onready var buy_energy: Button = %BuyEnergy
@onready var exit: Button = %Exit
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("on_effect")

func _on_buy_batery_button_down() -> void:
	pass # Replace with function body.

func _on_buy_energy_button_down() -> void:
	pass # Replace with function body.

func _on_exit_button_down() -> void:
	animation_player.play("off_effect")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "off_effect":
		get_tree().quit()
	

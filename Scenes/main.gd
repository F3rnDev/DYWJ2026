extends Node3D

@onready var ui = $UI

var finalVal = 0

func _ready() -> void:
	#WHEN YOU PAUSE THE GAME, OR MAKE A SPECIFIC MECHANIC N SHIT, CHANGE THIS MOUSE MODE
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_character_body_3d_can_start_interact(can: bool) -> void:
	ui.canInteract(can)

#Debug at this point
func _on_play_button_add_point(value: Variant) -> void:
	finalVal += value

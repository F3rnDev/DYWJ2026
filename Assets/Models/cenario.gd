extends Node3D

@onready var spotlights = [$SpotLight3D8, $SpotLight3D, $SpotLight3D7, $SpotLight3D2, $SpotLight3D3, $SpotLight3D4, $SpotLight3D5, $SpotLight3D6]
@onready var leverIndicator = $OmniLight3D2
@onready var buttonIndicator = $OmniLight3D3

func _ready() -> void:
	setLights(false, true)

func setLights(on:bool, isStart:bool = false):
	for spotlight in spotlights:
		spotlight.visible = on
	
	leverIndicator.visible = !on if !isStart else false
	buttonIndicator.visible = isStart

extends Node3D

@onready var ui = $UI

#Environment UI
@onready var bateryBar = $Objects/UI/bateryBar

@export var batteryAmnt = 50.0
@export var maxEnergy = 100.0

var curEnergy = 0.0
var extraBatteries:int = 0

var temperature = 0.0

# quanto maior a energia acumulada, maior o acumulo de pressão?
var pressure = 0.0 # 0 a 100, se estiver acima de 100, KABOOM

func _ready() -> void:
	#WHEN YOU PAUSE THE GAME, OR MAKE A SPECIFIC MECHANIC N SHIT, CHANGE THIS MOUSE MODE
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#SetBatery
	bateryBar.setMaxValue(maxEnergy)
	bateryBar.setCurValue(0.0)

func turnLights(on:bool):
	pass

func _on_character_body_3d_can_start_interact(can: bool, type:Crosshair.Types) -> void:
	ui.canInteract(can)
	ui.setCrosshair(type)

#Debug at this point
func _on_play_button_add_point(value: Variant) -> void:
	if value == null:
		return
	
	curEnergy += value
	bateryBar.setCurValue(curEnergy)
	
	if curEnergy > maxEnergy:
		pass
		#DO SOME SHIT

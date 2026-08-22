extends Node3D

@onready var ui = $UI

#Interactables
@onready var lever = $Objects/Interactables/lever
@onready var energyBtn = $Objects/Interactables/PlayButton

#Environment UI
@onready var cenario = $cenarioBlender
@onready var bateryBar = $Objects/UI/bateryBar

@export var batteryAmnt = 50.0
@export var maxEnergy = 100.0

var curEnergy = 0.0
var extraBatteries:int = 0
var energyEfficiency = 1.0

var coreUnstability = 0.0 #Controls game over
var temperature = 0.0
var pressure = 0.0


func _ready() -> void:
	#WHEN YOU PAUSE THE GAME, OR MAKE A SPECIFIC MECHANIC N SHIT, CHANGE THIS MOUSE MODE
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#SetBatery
	bateryBar.setMaxValue(maxEnergy)
	bateryBar.setCurValue(0.0)

func turnLights(on:bool):
	cenario.setLights(on)
	
	if !on:
		lever.moveLeverDown()
		#Mexer alavanca pra cima
		#Increase core unstability

func _on_character_body_3d_can_start_interact(can: bool, type:Crosshair.Types) -> void:
	ui.canInteract(can)
	ui.setCrosshair(type)

func _on_play_button_add_point() -> void:
	curEnergy += energyEfficiency
	bateryBar.setCurValue(curEnergy)
	
	energyBtn.instacePointAdd(energyEfficiency)
	
	if curEnergy > maxEnergy:
		turnLights(false)
		coreUnstability += 20.0
	elif curEnergy <= 0.0:
		turnLights(false)
	else:
		turnLights(true)

func _on_lever_switch_on() -> void:
	turnLights(true)

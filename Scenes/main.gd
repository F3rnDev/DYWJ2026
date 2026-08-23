extends Node3D

class_name MainGame

@onready var player = $CharacterBody3D

@onready var ui = $UI
@onready var tempRect = $UI/ColorRect

#Interactables
@onready var lever = $Objects/Interactables/lever
@onready var energyBtn = $Objects/Interactables/PlayButton

#Environment UI
@onready var cenario = $cenarioBlender
@onready var bateryBar = $Objects/UI/bateryBar

@export_category("Energy")
@export var batteryAmnt = 50.0
@export var maxEnergy = 100.0
@export var energyEfficiency = 1.0
@export var extraBatteries:int = 0

var coreStarted: bool = false
var lightsOn: bool = true

var curEnergy = 0.0

var coreUnstability: float = 0.0 #Controls game over
var temperature: float = 25.0
var pressure: float = 10.0

#Valve mechanic
@export_category("Pressure")
@onready var pressureValves = [$Objects/Interactables/Valve, $Objects/Interactables/Valve2]
var activePressureValve:Valve
@export var pressureTreshold = 50.0
var holdingRightValve = false

#Temperature mechanic
@export_category("Temperature")
@onready var tempButton = $Objects/Interactables/temperatureBtn
@export var tempIncrease = 50.0

#Store
@onready var store = $Objects/Interactables/Store

#Increase rate
@export_category("Rates")
@export var coreUnsRate: float = 5.0
@export var tempNormalRate: float = 8.0
@export var pressNormalRate: float = 5.0
@export var energyDropRate = 1.0

func setActiveValve():
	activePressureValve = pressureValves.pick_random()

func _ready() -> void:
	#WHEN YOU PAUSE THE GAME, OR MAKE A SPECIFIC MECHANIC N SHIT, CHANGE THIS MOUSE MODE
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#SetBatery
	bateryBar.setMaxValue(maxEnergy)
	bateryBar.setCurValue(0.0)

func _process(delta: float) -> void:
	if not coreStarted:
		return
	
	calculateValues(delta)
	valveMechanic(delta)
	
	#CHANGE THE ENVIRONMENT
	updateTempUI()
	updateEnergyUI()
	
	#DEBUG
	$UI/ProgressBar.value = coreUnstability
	$UI/ProgressBar2.value = temperature
	$UI/ProgressBar3.value = pressure

#UI
func updateEnergyUI():
	bateryBar.setCurValue(curEnergy)
	
	if curEnergy <= 0.0:
		turnLights(false)

func updateTempUI():
	var target_alpha = remap(temperature, 50.0, 100.0, 0.0, 1.0)
	tempRect.modulate.a = lerp(tempRect.modulate.a, target_alpha, 0.1)

func valveMechanic(delta):
	#Set active valve
	if pressure >= pressureTreshold and activePressureValve == null:
		setActiveValve()
	elif pressure < pressureTreshold:
		activePressureValve = null
	
	#If holding valve, release pressure
	if holdingRightValve:
		pressure -= pressNormalRate * 2.0 * delta
		pressure = clamp(pressure, 0.0, 100.0)

func calculateValues(delta):
	#Reduce energy
	curEnergy -= energyDropRate * delta
	
	# 1. Environmental penalties
	if not lightsOn:
		coreUnstability += coreUnsRate * delta
	
	# 2. Scale temp and pressure based on current instability
	var unstabilityMult: float = max(coreUnstability / 100.0, 0.1) # Prevent 0 multiplier if needed
	temperature += tempNormalRate * unstabilityMult * delta
	temperature = clamp(temperature, 0.0, 100.0)
	
	if !holdingRightValve:
		pressure += pressNormalRate * unstabilityMult * delta
		pressure = clamp(pressure, 0.0, 100.0)
	
	# 3. Threshold penalties (using accumulated penalty or separate checks)
	var penaltyCount: int = 0
	if temperature >= 80.0:
		penaltyCount += 1
	if pressure >= 80.0:
		penaltyCount += 1
		
	if penaltyCount > 0:
		coreUnstability += (coreUnsRate * penaltyCount) * delta

	# 4. Recovery condition
	if lightsOn and temperature <= 50.0 and pressure <= 50.0:
		coreUnstability -= coreUnsRate * delta
		coreUnstability = max(coreUnstability, 1.0)

func turnLights(on:bool):
	if on and !coreStarted:
		coreStarted = true
		
		for valve in pressureValves:
			valve.setActive(true)
		
		tempButton.setActive(true)
		store.setActive(true)
	
	lightsOn = on
	cenario.setLights(on)
	
	if !on:
		lever.moveLeverDown()
		forceCloseShop()
		store.active = false
	else:
		store.active = true

func _on_character_body_3d_can_start_interact(can: bool, type:Crosshair.Types) -> void:
	ui.canInteract(can)
	ui.setCrosshair(type)

func _on_play_button_add_point() -> void:
	curEnergy += energyEfficiency
	energyBtn.instacePointAdd(energyEfficiency)
	
	if curEnergy > maxEnergy:
		turnLights(false)
		coreUnstability += 20.0
	elif curEnergy <= 0.0:
		turnLights(false)
	elif curEnergy > 0.0 and !coreStarted:
		turnLights(true)

func _on_lever_switch_on() -> void:
	turnLights(true)

func _on_valve_started_drag(valve: Valve) -> void:
	if valve == activePressureValve:
		holdingRightValve = true
	else:
		holdingRightValve = false

func _on_valve_ended_drag(valve: Valve) -> void:
	holdingRightValve = false

func _on_temperature_btn_got_temp(right: bool) -> void:
	var mult = -1.0 if right else 1.0
	temperature += tempIncrease * mult

func _on_store_open_store() -> void:
	ui.openShop(self)
	player.isActive = false
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func buyUpgrade(type:UpgradeShop.UpgradeType):
	#Do stuff
	match type:
		UpgradeShop.UpgradeType.Battery:
			pass
		UpgradeShop.UpgradeType.Energy:
			pass

func forceCloseShop():
	if ui.shopUIInstance != null:
		ui.shopUIInstance.animation_player.play("off_effect")

func closeShop():
	player.isActive = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

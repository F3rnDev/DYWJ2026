extends Node3D

class_name MainGame

@export var tutorial:bool

@onready var player = $CharacterBody3D

@onready var ui = $UI
@onready var tempRect = $UI/ColorRect

#Interactables
@onready var lever = $Objects/Interactables/lever
@onready var energyBtn = $Objects/Interactables/PlayButton

#Environment UI
@onready var cenario = $Objects/cenarioBlender
@onready var bateryBarMain = $Objects/batteries/main/bateryBar

@onready var upg1: Node3D = $Objects/batteries/upg1
@onready var upg2: Node3D = $Objects/batteries/upg2
@onready var upg3: Node3D = $Objects/batteries/upg3
@onready var upg4: Node3D = $Objects/batteries/upg4
@onready var upgList = [upg1, upg2, upg3, upg4]

@onready var upg1Bar = $Objects/batteries/upg1/bateryBar
@onready var upg2Bar = $Objects/batteries/upg2/bateryBar
@onready var upg3Bar = $Objects/batteries/upg3/bateryBar
@onready var upg4Bar = $Objects/batteries/upg4/bateryBar
@onready var upgBarList = [upg1Bar, upg2Bar, upg3Bar, upg4Bar]

@onready var ponteiro: Node3D = $Objects/PONTEIRO
@onready var ponteiro_2: Node3D = $Objects/PONTEIRO2

@onready var nucleo: MeshInstance3D = $Objects/Nucleo



@export_category("Energy")
@export var baseEnergyMaxAmount = 100.0 
var maxEnergy
@export var baseEnergyEfficiency = 1.0

#Upgrades
@export var upgradeEffLevel:int = 0
@export var upgradeEffLevelLimit:int = 20
@export var extraBatteries:int = 0
@export var extraBatteriesLimit:int = 4
@export var extraBetteriesMult:float = 3.0

var coreStarted: bool = false
var lightsOn: bool = true

var curEnergy = 0.0

var coreUnstability: float = 0.0 #Controls game over
var coreUnstabilityMin:float = 1.0
var coreUnstabilityIncrease:float = 5.0

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

@export var energyIncreaseDropRate = 2.0
@onready var minInstabilityIncrease: Timer = $MinInstabilityIncrease


#Random energy outage
@onready var outageTimer = $OutageTimer
@export var chanceToOutage = 0.2 #20%

signal turnedLights(on)
signal openedShop(open)

func setActiveValve():
	activePressureValve = pressureValves.pick_random()

func _ready() -> void:
	#WHEN YOU PAUSE THE GAME, OR MAKE A SPECIFIC MECHANIC N SHIT, CHANGE THIS MOUSE MODE
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#SetBatery
	maxEnergy = baseEnergyMaxAmount
	
	bateryBarMain.setMaxValue(maxEnergy)
	bateryBarMain.setCurValue(0.0)
	
	#Set extra batteries
	for upg in upgList:
		upg.visible = false
	
	if !tutorial:
		player.isActive = false
		$UI/Intro/AnimationPlayer.play("start")
	else:
		$UI/Intro.visible = false
	
	$UI/DialogueUI/Canvas.visible = tutorial

func _process(delta: float) -> void:
	#Update ambient pitch based on the core
	$Audio/Ambient.pitch_scale = remap(coreUnstability, 0.0, 100.0, 0.5, 1.5)
	$Audio/Ambient.volume_db = remap(coreUnstability, 0.0, 100.0, -30.0, -20.0)
	
	if not coreStarted:
		return
	
	if !tutorial:
		calculateValues(delta)
	
	valveMechanic(delta)
	
	#CHANGE THE ENVIRONMENT
	updateTempUI()
	updateEnergyUI()
	ponteiro.setTemp(temperature)
	ponteiro_2.setTemp(temperature)
	nucleo.update_visuals(coreUnstability)
	cenario.setUnstableIndicator(coreUnstability > 65.0)
	
	if coreUnstability > 65.0 and coreUnstability <= 100.0 and !$Audio/Alarm.playing:
		$Audio/Alarm.play()
	elif coreUnstability <= 65.0 and $Audio/Alarm.playing:
		$Audio/Alarm.stop()
	
	if pressure > 65.0 and activePressureValve != null:
		activePressureValve.emitGas(true)
		
		if cenario.activeTubo == null:
			cenario.setActiveTubo(pressureValves.find(activePressureValve))
	elif pressure <= 20.0:
		for valve in pressureValves:
			valve.emitGas(false)
		
		cenario.setActiveTubo(-1)
	
	#GameOver
	if coreUnstability >= 100.0:
		gameOver(delta)
	
	#WinGame
	if upgradeEffLevel >= upgradeEffLevelLimit and extraBatteries >= extraBatteriesLimit:
		$UI/winGame.visible = true
		winGameSection(delta)
	else:
		$UI/winGame.visible = false

#UI
func updateEnergyUI() -> void:
	# Calculate the capacity limit for a single individual battery bar
	var curBattery: int = extraBatteries + 1
	var capacityPerBar: float = maxEnergy / curBattery
	
	# 1. Update the Main Battery Bar (it handles energy from 0 up to capacityPerBar)
	var mainBarEnergy: float = min(curEnergy, capacityPerBar)
	bateryBarMain.setCurValue(mainBarEnergy)
	
	# Track how much energy is left to distribute to the extra upgrade bars
	var leftoverEnergy: float = curEnergy - mainBarEnergy
	
	# 2. Cascade the leftover energy through upgBarList
	for i in range(upgBarList.size()):
		var bar = upgBarList[i]
		
		# Only update bars that are actually unlocked/visible
		if bar.visible:
			var barEnergy: float = min(leftoverEnergy, capacityPerBar)
			bar.setCurValue(barEnergy)
			leftoverEnergy -= barEnergy # Subtract what this bar consumed
		else:
			# If the bar isn't unlocked, make sure it's empty
			bar.setCurValue(0.0)

	# 3. Handle lights out condition
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
	curEnergy = max(0.0, curEnergy)
	
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
		coreUnstability = max(coreUnstability, coreUnstabilityMin)

var lastStatus = null
func turnLights(on:bool):
	if on and !coreStarted:
		coreStarted = true
		
		for valve in pressureValves:
			valve.setActive(true)
		
		if !tutorial:
			tempButton.setActive(true)
			store.setActive(true)
			
			minInstabilityIncrease.start()
			outageTimer.start()
	
	lightsOn = on
	cenario.setLights(on)
	
	if !on:
		lever.moveLeverDown(tutorial)
		forceCloseShop()
		store.active = false
	else:
		store.active = true if !tutorial else false
	
	if lastStatus != on:
		if on:
			$Audio/PowerOn.play()
		else:
			$Audio/PowerOff.play()
	
	lastStatus = on
	
	turnedLights.emit(on)

func _on_character_body_3d_can_start_interact(can: bool, type:Crosshair.Types) -> void:
	ui.canInteract(can)
	ui.setCrosshair(type)

func _on_play_button_add_point() -> void:
	var energyAmnt = baseEnergyEfficiency + upgradeEffLevel
	
	curEnergy += energyAmnt
	energyBtn.instacePointAdd(energyAmnt)
	
	if curEnergy > maxEnergy:
		if upgradeEffLevel >= upgradeEffLevelLimit and extraBatteries >= extraBatteriesLimit:
			winGame()
			return
		
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
	
	openedShop.emit(true)

func buyUpgrade(type:UpgradeShop.UpgradeType):
	#Do stuff
	match type:
		UpgradeShop.UpgradeType.Battery:
			if extraBatteries >= extraBatteriesLimit:
				return
			
			extraBatteries += 1
			
			var curBattery = extraBatteries+1
			var energyMult = curBattery + (extraBetteriesMult*curBattery)
			var newMaxEnergy = baseEnergyMaxAmount * energyMult
			maxEnergy = max(1.0, newMaxEnergy)
			
			upgList[extraBatteries-1].visible = true
			bateryBarMain.setMaxValue(maxEnergy/curBattery)
			
			for bar in upgBarList:
				bar.setMaxValue(maxEnergy/curBattery)
			
		UpgradeShop.UpgradeType.Energy:
			if upgradeEffLevel >= upgradeEffLevelLimit:
				return
			
			upgradeEffLevel += 1

func forceCloseShop():
	if ui.shopUIInstance != null:
		ui.shopUIInstance.animation_player.play("off_effect")
	
	openedShop.emit(false)

func closeShop():
	player.isActive = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	openedShop.emit(false)

func gameOver(delta: float) -> void:
	player.isActive = false
	
	var current_player_transform: Transform3D = player.global_transform
	var target_transform: Transform3D = current_player_transform.looking_at(nucleo.global_position, Vector3.UP)
	player.global_transform = current_player_transform.interpolate_with(target_transform, 5.0 * delta)
	
	var cam_current = $CharacterBody3D/Camera3D.global_transform
	var cam_target = cam_current.looking_at(nucleo.global_position, Vector3.UP)
	$CharacterBody3D/Camera3D.global_transform = cam_current.interpolate_with(cam_target, 5.0 * delta)
	
	if $gameOverDelay.is_stopped():
		$gameOverDelay.start()
	
	$UI/CrossHair.visible = false
	$UI/Label.visible = false

func winGameSection(delta):
	var min = 0.0
	var max = maxEnergy
	var cur = curEnergy
	
	$UI/winGame.modulate.a = remap(cur, min, max, 0.0, 1.0)

func winGame():
	get_tree().change_scene_to_file("res://GameAssets/ui/Menus/WinGame.tscn")

func _on_min_instability_increase_timeout() -> void:
	energyDropRate += energyIncreaseDropRate
	coreUnstabilityMin += coreUnstabilityIncrease
	
	minInstabilityIncrease.start()

func _on_outage_timer_timeout() -> void:
	if tutorial:
		return
	
	if randf() < 0.2:
		turnLights(false)
	
	outageTimer.start()


func _on_game_over_delay_timeout() -> void:
	$UI/GameOverRect.visible = true
	if !$Audio/Explosion.playing:
		$Audio/Explosion.play()
		$Audio/Ambient.stop()
		$Audio/Alarm.stop()
		
		for valve in pressureValves:
			valve.stopAudios()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	player.isActive = true

func _on_explosion_finished() -> void:
	get_tree().change_scene_to_file("res://GameAssets/ui/Menus/game_over.tscn")

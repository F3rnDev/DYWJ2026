extends Control

class_name UpgradeShop

var baseBatteryCost = 80.0
var batteryMult = 6.0

var baseEnergyCost = 20.0
var energyMult = 3.0

@onready var buy_batery: Button = %BuyBatery
@onready var buy_energy: Button = %BuyEnergy
@onready var exit: Button = %Exit
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#Core Status variable
@onready var curEnergy = $Sections/Status/EnergyInfo/MarginContainer/VBoxContainer/Current
@onready var EPC = $Sections/Status/EnergyInfo/MarginContainer/VBoxContainer/EPC
@onready var totalBatery: Label = $Sections/Status/EnergyInfo/MarginContainer/VBoxContainer/TotalBatery
@onready var bateryCapacity: Label = $Sections/Status/EnergyInfo/MarginContainer/VBoxContainer/BateryCpacity

@onready var pressure: Label = $Sections/Status/EnergyInfo/MarginContainer/VBoxContainer/CosumePressure
@onready var temperature: Label = $Sections/Status/EnergyInfo/MarginContainer/VBoxContainer/ConsumeTemperature
@onready var core: Label = $Sections/Status/EnergyInfo/MarginContainer/VBoxContainer/ConsumeCore

#Upgrades variable
@onready var batteryUpgrade:Label = $Sections/Upgrades/VBoxContainer/BateryUpgrade/MarginContainer/VBoxContainer/Tittle
@onready var batteryUpgradeCost: Label = $Sections/Upgrades/VBoxContainer/BateryUpgrade/MarginContainer/VBoxContainer/Cost

@onready var energyUpgrade: Label = $Sections/Upgrades/VBoxContainer/EnergyUpgrade/MarginContainer/VBoxContainer/Tittle
@onready var energyUpgradeCost: Label = $Sections/Upgrades/VBoxContainer/EnergyUpgrade/MarginContainer/VBoxContainer/Cost

enum UpgradeType{
	Battery,
	Energy
}

var mainGameRef:MainGame = null

signal boughtUpgrade(upg:UpgradeType)
signal exitedShop

func _ready() -> void:
	animation_player.play("on_effect")
	$Audio/Enter.play()

func _process(delta: float) -> void:
	if mainGameRef == null: return
	
	updateUIInfo()
	updateUIUpgrades()

func setMainGameRef(ref):
	mainGameRef = ref
	
	boughtUpgrade.connect(mainGameRef.buyUpgrade)
	exitedShop.connect(mainGameRef.closeShop)

func updateUIInfo():
	#Energy info
	curEnergy.text = "Current Energy: %den" % mainGameRef.curEnergy
	EPC.text = "Energy per click: %den" % (mainGameRef.baseEnergyEfficiency + mainGameRef.upgradeEffLevel)
	totalBatery.text = "Total battery: %d" % mainGameRef.extraBatteries
	
	var batteryCapacity = mainGameRef.maxEnergy
	bateryCapacity.text = "Battery capacity: %den" % batteryCapacity
	
	#Core status
	pressure.text = "Pressure system: %d%%" % mainGameRef.pressure
	temperature.text = "Temperature system: %d%%" % mainGameRef.temperature
	core.text = "Core stability: %d%%" % mainGameRef.coreUnstability

func updateUIUpgrades():
	#Title texts
	batteryUpgrade.text = "Battery\n(%d/%d)" % [mainGameRef.extraBatteries, mainGameRef.extraBatteriesLimit]
	energyUpgrade.text = "Energy Gen.\n(%d/%d)" % [mainGameRef.upgradeEffLevel, mainGameRef.upgradeEffLevelLimit]
	
	#Cost
	var batteryCost = baseBatteryCost * max(mainGameRef.extraBatteries * batteryMult, 1.0)
	var energyCost = baseEnergyCost * max(mainGameRef.upgradeEffLevel * energyMult, 1.0)
	
	batteryUpgradeCost.text = "Cost: %den" % batteryCost
	energyUpgradeCost.text = "Cost: %den"% energyCost
	
	#Update Button Status
	buy_batery.disabled = batteryCost > mainGameRef.curEnergy
	buy_energy.disabled = energyCost > mainGameRef.curEnergy

func _on_buy_batery_button_down() -> void:
	var batteryCost = baseBatteryCost * max(mainGameRef.extraBatteries * batteryMult, 1.0)
	
	mainGameRef.curEnergy -= batteryCost
	boughtUpgrade.emit(UpgradeType.Battery)

func _on_buy_energy_button_down() -> void:
	var energyCost = baseEnergyCost * max(mainGameRef.upgradeEffLevel * energyMult, 1.0)
	
	mainGameRef.curEnergy -= energyCost
	boughtUpgrade.emit(UpgradeType.Energy)

func _on_exit_button_down() -> void:
	$Audio/ClickMenu.play()
	animation_player.play("off_effect")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "off_effect":
		exitedShop.emit()
		queue_free()

func _on_mouse_entered() -> void:
	$Audio/HoverMenu.play()

func _on_upgrade_button_down() -> void:
	$Audio/Upgrade.play()

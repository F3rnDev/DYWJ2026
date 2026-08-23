extends Control

class_name UpgradeShop

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


enum UpgradeType{
	Battery,
	Energy
}

var mainGameRef:MainGame = null

signal boughtUpgrade(upg:UpgradeType)
signal exitedShop

func _ready() -> void:
	animation_player.play("on_effect")

func _process(delta: float) -> void:
	updateUIInfo()

func setMainGameRef(ref):
	mainGameRef = ref
	
	boughtUpgrade.connect(mainGameRef.buyUpgrade)
	exitedShop.connect(mainGameRef.closeShop)

func updateUIInfo():
	if mainGameRef == null:
		return
	
	#Energy info
	curEnergy.text = "Current Energy: %den" % mainGameRef.curEnergy
	EPC.text = "Energy per click: %den" % mainGameRef.energyEfficiency
	totalBatery.text = "Total battery: %d" % mainGameRef.extraBatteries
	
	var batteryCapacity = mainGameRef.batteryAmnt * max(mainGameRef.extraBatteries, 1.0)
	bateryCapacity.text = "Battery capacity: %den" % batteryCapacity
	
	#Core status
	pressure.text = "Pressure system: %d%%" % mainGameRef.pressure
	temperature.text = "Temperature system: %d%%" % mainGameRef.temperature
	core.text = "Core stability: %d%%" % mainGameRef.coreUnstability

func _on_buy_batery_button_down() -> void:
	boughtUpgrade.emit(UpgradeType.Battery)

func _on_buy_energy_button_down() -> void:
	boughtUpgrade.emit(UpgradeType.Energy)

func _on_exit_button_down() -> void:
	animation_player.play("off_effect")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "off_effect":
		exitedShop.emit()
		queue_free()
	

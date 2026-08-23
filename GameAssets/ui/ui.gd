extends CanvasLayer

@onready var shopUI = preload("res://GameAssets/ui/Menus/upgrade_shop_ui.tscn")
var shopUIInstance:UpgradeShop = null

@onready var interactLabel = $Label
@onready var crosshairImg = $CrossHair

#Dict
@export var crosshairDict:Dictionary[Crosshair.Types, Texture]
var curCrosshair:Crosshair.Types = Crosshair.Types.CROSSHAIR

func canInteract(can:bool):
	interactLabel.visible = can

func setCrosshair(type:Crosshair.Types):
	if type in crosshairDict:
		crosshairImg.texture = crosshairDict[type]
		curCrosshair = type
		
		changeText()

func changeText():
	match curCrosshair:
		Crosshair.Types.READYTOCLICK:
			interactLabel.text = "Click to Interact"
		Crosshair.Types.READYTOHOLD:
			interactLabel.text = "Hold to Interact"
		_:
			interactLabel.text = ""

func interactCrosshair(interacted:bool):
	match curCrosshair:
		Crosshair.Types.READYTOCLICK:
			if interacted:
				crosshairImg.texture = crosshairDict[Crosshair.Types.CLICK]
			else:
				crosshairImg.texture = crosshairDict[Crosshair.Types.READYTOCLICK]
		
		Crosshair.Types.READYTOHOLD:
			if interacted:
				crosshairImg.texture = crosshairDict[Crosshair.Types.HOLD]
			else:
				crosshairImg.texture = crosshairDict[Crosshair.Types.READYTOHOLD]

func openShop(mainGame:MainGame):
	shopUIInstance = shopUI.instantiate()
	add_child(shopUIInstance)
	
	shopUIInstance.setMainGameRef(mainGame)
	shopUIInstance.exitedShop.connect(closeShop)

func closeShop():
	shopUIInstance = null

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact"):
		interactCrosshair(true)
	elif Input.is_action_just_released("Interact"):
		interactCrosshair(false)

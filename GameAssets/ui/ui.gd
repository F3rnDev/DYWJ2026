extends CanvasLayer

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

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact"):
		interactCrosshair(true)
	elif Input.is_action_just_released("Interact"):
		interactCrosshair(false)

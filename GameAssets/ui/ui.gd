extends CanvasLayer

@onready var interactLabel = $Label

func canInteract(can:bool):
	interactLabel.visible = can

extends Interactor

class_name Valve

var crosshair:Crosshair.Types = Crosshair.Types.READYTOHOLD

var dragging = false

@export var degreeAmnt = 1.0

func playInteractor():
	dragging = true

func resetInteractor():
	dragging = false

func _process(delta: float) -> void:
	if dragging:
		moveLever()

func moveLever():
	rotation_degrees.z += degreeAmnt

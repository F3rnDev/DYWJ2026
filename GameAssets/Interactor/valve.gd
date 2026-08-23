extends Interactor

class_name Valve

var crosshair:Crosshair.Types = Crosshair.Types.READYTOHOLD

var dragging = false

@export var degreeAmnt = 1.0

signal startedDrag(valve:Valve)
signal endedDrag(valve:Valve)

func playInteractor():
	super.playInteractor()
	
	dragging = true
	startedDrag.emit(self)

func resetInteractor():
	super.resetInteractor()
	
	dragging = false
	endedDrag.emit(self)

func _process(delta: float) -> void:
	if dragging:
		moveLever()

func moveLever():
	rotation_degrees.z += degreeAmnt

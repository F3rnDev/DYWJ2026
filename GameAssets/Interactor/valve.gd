extends Interactor

class_name Valve

var crosshair:Crosshair.Types = Crosshair.Types.READYTOHOLD

var dragging = false

@export var degreeAmnt = 1.0

func _ready() -> void:
	setActive(true)

func playInteractor():
	super.playInteractor()
	
	dragging = true

func resetInteractor():
	super.resetInteractor()
	
	dragging = false

func _process(delta: float) -> void:
	if dragging:
		moveLever()

func moveLever():
	rotation_degrees.z += degreeAmnt

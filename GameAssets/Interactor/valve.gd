extends Interactor

class_name Valve

var crosshair:Crosshair.Types = Crosshair.Types.READYTOHOLD

var dragging = false
var isActive = false

@export var degreeAmnt = 1.0

signal startedDrag(valve:Valve)
signal endedDrag(valve:Valve)

#SHAKE
var max_shake_intensity = 0.01
var mesh_original_position: Vector3

func _ready() -> void:
	emitGas(false)
	
	mesh_original_position = objectMesh.position

func playInteractor():
	super.playInteractor()
	
	dragging = true
	startedDrag.emit(self)

func resetInteractor():
	super.resetInteractor()
	
	dragging = false
	endedDrag.emit(self)
	
	if get_node_or_null("TurnValve") != null:
		$TurnValve.stop()

func _process(delta: float) -> void:
	if dragging:
		moveLever()
	
	if isActive:
		shakeMesh()

var lastGasPos = false

func stopAudios():
	$Tremble.queue_free()
	$ReleasePressure.queue_free()
	$TurnValve.queue_free()

func emitGas(yes:bool):
	$Gas.emitting = yes
	isActive = yes
	
	objectMesh.position = mesh_original_position
	
	if lastGasPos != yes and get_node_or_null("ReleasePressure") != null and get_node_or_null("Tremble") != null:
		if !yes:
			$ReleasePressure.play()
			$Tremble.stop()
		else:
			$Tremble.play()
	
	lastGasPos = yes

func shakeMesh():
	var shake_offset = Vector3(
		randf_range(-max_shake_intensity, max_shake_intensity),
		randf_range(-max_shake_intensity, max_shake_intensity),
		randf_range(-max_shake_intensity, max_shake_intensity)
	)
	objectMesh.position = mesh_original_position + shake_offset

func moveLever():
	rotation_degrees.z += degreeAmnt
	
	if get_node_or_null("TurnValve") != null and !$TurnValve.playing:
		$TurnValve.play()

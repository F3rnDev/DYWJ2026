extends Node3D

@onready var spotlights = [$SpotLight3D, $SpotLight3D7, $SpotLight3D2, $SpotLight3D3, $SpotLight3D4, $SpotLight3D5, $SpotLight3D6, $SpotLight3D8]
@onready var leverIndicator = $OmniLight3D3
@onready var buttonIndicator = $OmniLight3D4
@onready var coreUnstableIndicator = $OmniLight3D2

@onready var tubulação = [$cenarioBlender/tubovalvula2, $cenarioBlender/tubovalvula1]
var activeTubo = null

#SHAKE
var max_shake_intensity = 0.01
var mesh_original_position: Vector3

func _ready() -> void:
	setLights(false, true)
	setUnstableIndicator(false)

func _process(delta: float) -> void:
	if activeTubo != null:
		shakeTubo()

func setLights(on:bool, isStart:bool = false):
	for spotlight in spotlights:
		spotlight.visible = on
	
	leverIndicator.visible = !on if !isStart else false
	buttonIndicator.visible = isStart

func setUnstableIndicator(unstable:bool):
	coreUnstableIndicator.visible = unstable

func setActiveTubo(id:int=-1):
	if id == -1:
		if activeTubo != null:
			activeTubo.global_position = mesh_original_position
			activeTubo = null
		return
	
	mesh_original_position = tubulação[id].global_position
	activeTubo = tubulação[id]

func shakeTubo():
	var shake_offset = Vector3(
		randf_range(-max_shake_intensity, max_shake_intensity),
		randf_range(-max_shake_intensity, max_shake_intensity),
		randf_range(-max_shake_intensity, max_shake_intensity)
	)
	activeTubo.global_position = mesh_original_position + shake_offset

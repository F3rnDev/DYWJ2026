extends Area3D

class_name Interactor

@onready var outlineMat:ShaderMaterial = preload("res://Assets/Mat/outline_simple.tres")
@export var objectMesh:MeshInstance3D

var active = false

func setActive(val:bool):
	active = val

func playFunction(function:String):
	if !active and function != "deactivateInteractor": return
	
	call(function)

func playInteractor():
	pass

func activateInteractor():
	if objectMesh == null: return
	
	objectMesh.material_overlay = outlineMat

func deactivateInteractor():
	if objectMesh == null: return
	
	objectMesh.material_overlay = null

func stoppedClicking():
	pass

func resetInteractor():
	pass

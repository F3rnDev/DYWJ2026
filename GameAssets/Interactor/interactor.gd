extends Area3D

class_name Interactor

@onready var outlineMat:BaseMaterial3D = preload("res://Assets/Mat/outline_simple.tres")
@export var objectMesh:MeshInstance3D

func playInteractor():
	pass

func activateInteractor():
	objectMesh.material_overlay = outlineMat

func deactivateInteractor():
	objectMesh.material_overlay = null

func resetInteractor():
	pass

extends Interactor

class_name PlayButton

@onready var pointAdd = preload("res://GameAssets/ui/pointAdd.tscn")

signal addPoint(value:int)

func playInteractor():
	addPoint.emit(1)
	
	var instance = pointAdd.instantiate()
	instance.create(1)
	add_child(instance)

extends Interactor

class_name PlayButton

var crosshair:Crosshair.Types = Crosshair.Types.READYTOCLICK

@onready var pointAdd = preload("res://GameAssets/ui/pointAdd.tscn")
@onready var anim = $buttonAnim

signal addPoint(value:int)

func playInteractor():
	addPoint.emit(1)
	
	var instance = pointAdd.instantiate()
	instance.create(1)
	add_child(instance)
	
	anim.stop()
	anim.play("press")

extends Interactor

class_name PlayButton

var crosshair:Crosshair.Types = Crosshair.Types.READYTOCLICK

@onready var pointAdd = preload("res://GameAssets/ui/pointAdd.tscn")
@onready var anim = $buttonAnim

signal addPoint

func _ready() -> void:
	setActive(true)

func playInteractor():
	addPoint.emit()
	
	anim.stop()
	anim.play("press")

func instacePointAdd(curEff:float):
	var instance = pointAdd.instantiate()
	instance.create(curEff)
	add_child(instance)

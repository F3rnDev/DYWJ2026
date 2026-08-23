extends Interactor

class_name Store

var crosshair:Crosshair.Types = Crosshair.Types.READYTOCLICK

signal openStore

func playInteractor():
	openStore.emit()

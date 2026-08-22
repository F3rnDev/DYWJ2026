extends Sprite3D

@onready var progressBar = $SubViewport/ProgressBar

func setMaxValue(max):
	progressBar.max_value = max

func setCurValue(val):
	progressBar.value = val

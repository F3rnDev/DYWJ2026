extends Sprite3D

@onready var progressBar: ProgressBar = $SubViewport/ProgressBar

func setMaxValue(max):
	if progressBar == null or max == null:
		return
	
	progressBar.max_value = max

func setCurValue(val):
	if progressBar == null or val == null:
		return
	
	progressBar.value = val

extends Interactor

class_name TemperatureButton

var crosshair:Crosshair.Types = Crosshair.Types.READYTOCLICK

@onready var anim = $buttonAnim

@onready var subviewport = $Sprite3D/SubViewport
@onready var mover = $Sprite3D/SubViewport/Panel/mover
@export var moverSpeed = 20.0
@onready var clickArea = $Sprite3D/SubViewport/Panel/clickArea

var direction: float = 1.0 
var canInteract = true
@export var click_cooldown: float = 0.5

signal gotTemp(right:bool)

func _process(delta: float) -> void:
	var viewport_size = subviewport.size
	
	# Calculate the lowest valid Y position for the bar
	# (Viewport height minus the bar's own height)
	var max_y = viewport_size.y - mover.size.y
	
	# Move the bar
	mover.position.y += moverSpeed * direction * delta
	
	# Hit bottom boundary (accounting for mover height)
	if mover.position.y >= max_y:
		mover.position.y = max_y # Clamp to the exact bottom edge
		direction = -1.0
		
	# Hit top boundary
	elif mover.position.y <= 0:
		mover.position.y = 0 # Clamp to the exact top edge
		direction = 1.0

func playInteractor():
	# If the cooldown is active, exit the function immediately
	if not canInteract:
		return
		
	# Lock the interaction immediately so spamming does nothing
	canInteract = false

	# Your original interaction logic
	var mover_rect = mover.get_global_rect()
	var area_rect = clickArea.get_global_rect()
	var isCol = mover_rect.intersects(area_rect)

	gotTemp.emit(isCol)
	
	anim.stop()
	anim.play("press")
	
	$Click.pitch_scale = randf_range(0.8, 1.2)
	$Click.play()

	# Wait for the specified delay, then unlock the interaction
	await get_tree().create_timer(click_cooldown).timeout
	canInteract = true

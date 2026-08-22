extends Interactor

class_name Lever

var crosshair:Crosshair.Types = Crosshair.Types.READYTOHOLD

@export var min_angle: float = -145.0
@export var max_angle: float = 0.0
@export var mouse_sensitivity: float = 0.5

var dragging = false
var mouseOffset = Vector2(0, 0)

signal switchOn

func playInteractor():
	dragging = true

func resetInteractor():
	if !dragging:
		return
	
	dragging = false
	
	#UpdateRotation
	var animateOn = true
	if rotation_degrees.x < -25.0:
		animateOn = false
	
	animateLever(animateOn)

func moveLeverDown():
	var leverTween = create_tween()
	leverTween.tween_property(self, "rotation_degrees:x", min_angle, 0.2)
	setActive(true)

func animateLever(on):
	var angleToAnimate = max_angle if on else min_angle
	
	var leverTween = create_tween()
	leverTween.tween_property(self, "rotation_degrees:x", angleToAnimate, 0.2)
	
	if !on:
		return
	
	await leverTween.finished
	
	switchOn.emit()
	setActive(false)

func _input(event: InputEvent) -> void:
	if !dragging:
		return
	
	if event is InputEventMouseMotion:
		moveLever(event.relative)

func moveLever(mouse_relative: Vector2) -> void:
	var rotation_change = mouse_relative.y * mouse_sensitivity
	rotation_degrees.x -= rotation_change
	rotation_degrees.x = clamp(rotation_degrees.x, min_angle, max_angle)

extends Interactor

class_name Lever

var crosshair:Crosshair.Types = Crosshair.Types.READYTOHOLD

@export var min_angle: float = -90.0
@export var max_angle: float = 0.0
@export var mouse_sensitivity: float = 0.5

var dragging = false
var mouseOffset = Vector2(0, 0)

signal switch(on:bool)

func playInteractor():
	dragging = true

func resetInteractor():
	dragging = false
	
	#UpdateRotation
	var animateOn = true
	if rotation_degrees.x < -45.0:
		animateOn = false
	
	animateLever(animateOn)

func animateLever(on):
	var angleToAnimate = max_angle if on else min_angle
	
	var leverTween = create_tween()
	leverTween.tween_property(self, "rotation_degrees:x", angleToAnimate, 0.2)
	
	await leverTween.finished
	
	switch.emit(on)

func _input(event: InputEvent) -> void:
	if dragging and event is InputEventMouseMotion:
		moveLever(event.relative)

func moveLever(mouse_relative: Vector2) -> void:
	var rotation_change = mouse_relative.y * mouse_sensitivity
	rotation_degrees.x -= rotation_change
	rotation_degrees.x = clamp(rotation_degrees.x, min_angle, max_angle)

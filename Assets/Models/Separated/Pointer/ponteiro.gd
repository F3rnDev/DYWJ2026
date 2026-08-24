extends Node3D

@export var minRot = -90.0
@export var maxRot = 90.0

func setTemp(value):
	var min = 0.0
	var max = 100.0
	
	var clamped_value = clamp(value, min, max)
	var target_rot_deg = remap(clamped_value, min, max, minRot, maxRot)
	
	rotation_degrees.z = target_rot_deg

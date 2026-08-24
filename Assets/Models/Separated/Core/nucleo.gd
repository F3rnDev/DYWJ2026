extends MeshInstance3D

@export var max_instability: float = 100.0

# Scale settings
@export var min_scale: Vector3 = Vector3(0.415, 0.415, 0.415)
@export var max_scale: Vector3 = Vector3(1.0, 1.0, 1.0)

# Shake settings
@export var max_shake_intensity: float = 0.05

# References to nodes (adjust paths or export them)
@onready var light: OmniLight3D = $OmniLight3D # Or SpotLight3D / OmniLight3D

var original_position: Vector3

func _ready() -> void:
	original_position = position

func update_visuals(core_unstability: float) -> void:
	# 1. Normalize instability from 0.0 to 1.0 (clamped so it doesn't break if it goes over 100)
	var t: float = clamp(core_unstability / max_instability, 0.0, 1.0)
	
	# 2. Scale up smoothly based on instability
	var current_scale = min_scale.lerp(max_scale, t)
	scale = current_scale # Scales the whole object (or apply to sprite.scale)
	
	# 3. Shake more violently as t increases
	if t > 0.1: # Only shake once instability starts rising a bit
		var shake_offset = Vector3(
			randf_range(-max_shake_intensity, max_shake_intensity),
			randf_range(-max_shake_intensity, max_shake_intensity),
			randf_range(-max_shake_intensity, max_shake_intensity)
		) * t # Multiply by t so it shakes harder the closer it gets to 100
		position = original_position + shake_offset
	else:
		position = original_position
		
	# 4. Brighter light intensity (assuming a PointLight2D with a 'energy' property)
	if light and core_unstability > 65.0:
		# Scales energy from a baseline of 1.0 up to 5.0 (adjust as needed)
		light.light_energy = lerp(light.light_energy, 12.0, t-0.5)
	
	# 5. Changes outline thickness
	var overlay_mat = material_overlay as ShaderMaterial
	if not overlay_mat:
		return
	
	# Map t to your desired thickness range (0.0 to 0.01)
	var target_thickness: float = lerp(0.0, 0.1, t)
	
	# Pass it into your shader's thickness uniform 
	# (Replace "outline_thickness" with whatever exact name your shader uses for the thickness variable)
	overlay_mat.set_shader_parameter("thickness", target_thickness)

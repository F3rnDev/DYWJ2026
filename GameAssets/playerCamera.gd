extends Camera3D

var isShaking = false

func _camera_shake(magnitude = 0.4, period = 0.3):
	if isShaking:
		return
	
	var initial_transform = self.transform
	var elapsed_time = 0.0
	isShaking = true

	while elapsed_time < period:
		var offset = Vector3(
			randf_range(-magnitude, magnitude),
			randf_range(-magnitude, magnitude),
			0.0
		)

		self.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	self.transform = initial_transform
	isShaking = false

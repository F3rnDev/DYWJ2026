extends CharacterBody3D

var SPEED = 5.0

#Camera Logic
var lookDir:Vector2
@onready var camera = $Camera3D
var camSens = 50

#RayCast
@onready var raycast = $Camera3D/RayCast3D
var raycastedObject:Interactor = null

signal canStartInteract(can:bool, crosshairType:Crosshair.Types)

func rotateCam(delta, sensMod = 1.0):
	rotation.y -= lookDir.x * camSens * delta
	camera.rotation.x = clamp(camera.rotation.x - lookDir.y * camSens * sensMod * delta, -1.5, 1.5)
	
	lookDir = Vector2.ZERO

func checkRaycast():
	var alreadyCollided = true if raycastedObject != null else false
	if raycast.is_colliding() == alreadyCollided:
		return
	
	var collider = raycast.get_collider()
	if raycast.is_colliding() and collider.is_in_group("Interactor"):
		raycastedObject = collider
		raycastedObject.activateInteractor()
	else:
		if raycastedObject != null:
			raycastedObject.resetInteractor()
		
		raycastedObject = null
	
	var renderCrosshair = Crosshair.Types.CROSSHAIR
	if collider != null and "crosshair" in collider:
		renderCrosshair = collider.crosshair
	
	canStartInteract.emit(raycastedObject != null, renderCrosshair)

func Interact():
	if raycastedObject != null:
		raycastedObject.playInteractor()

func _process(delta: float) -> void:
	rotateCam(delta)
	
	checkRaycast()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: lookDir = event.relative * 0.01
	
	if Input.is_action_just_pressed("Interact"):
		Interact()
	elif Input.is_action_just_released("Interact") and raycastedObject != null:
		raycastedObject.resetInteractor()
	
	#DEBUG
	if Input.is_physical_key_pressed(KEY_0):
		camera._camera_shake(0.5, 2.0)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

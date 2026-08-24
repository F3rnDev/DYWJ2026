extends Node

@onready var tempLocation = $TempLocation
@onready var valve_location_1: OmniLight3D = $ValveLocation1
@onready var valve_location_2: OmniLight3D = $ValveLocation2
@onready var shop_location: OmniLight3D = $ShopLocation


@export var game:MainGame

@export var dialogueTrigger:DialogueTrigger
@export var circuitBreaker:Lever
@export var playButton:PlayButton
@export var tempButton:TemperatureButton
@export var shop:Store

func _ready() -> void:
	playButton.active = false
	shop.active = false
	dialogueTrigger.start_dialogue()
	
	dialogueTrigger.endedDialogue.connect(_on_dialogue_end)
	game.turnedLights.connect(_on_node_3d_turned_lights)
	game.openedShop.connect(_on_open_shop)
	tempButton.gotTemp.connect(_on_got_temp)
	
	controlDialogue()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact") and !dialogueTrigger.cantSkip:
		dialogueTrigger.continue_dialogue()
		controlDialogue()

func controlDialogue():
	match dialogueTrigger.current_dialogue:
		5:
			playButton.active = true
		9:
			circuitBreaker.active = true
		11:
			game.curEnergy = 0.0
		13:
			playButton.active = true
			circuitBreaker.active = true
		19:
			tempLocation.visible = true
			tempButton.active = true
		25:
			valve_location_1.visible = true
			valve_location_2.visible = true
			game.pressure = 100.0
		28:
			shop.active = true
			shop_location.visible = true

func _process(delta: float) -> void:
	if game.pressure <= 20.0 and dialogueTrigger.current_dialogue == 26:
		dialogueTrigger.continue_dialogue()
		valve_location_1.visible = false
		valve_location_2.visible = false

func _on_node_3d_turned_lights(on: Variant) -> void:
	if dialogueTrigger.current_dialogue == 5 and game.curEnergy >= game.maxEnergy:
		dialogueTrigger.continue_dialogue()
		playButton.active = false
	elif dialogueTrigger.current_dialogue == 9 and on:
		dialogueTrigger.continue_dialogue()
	elif dialogueTrigger.current_dialogue == 13 and on:
		playButton.active = false
		dialogueTrigger.continue_dialogue()

func _on_got_temp(right):
	if right and dialogueTrigger.current_dialogue == 20:
		dialogueTrigger.continue_dialogue()
		tempButton.active = false
		tempLocation.visible = false

func _on_open_shop(open):
	if open and dialogueTrigger.current_dialogue == 28:
		dialogueTrigger.continue_dialogue()

func _on_dialogue_end():
	$CanvasLayer/ColorRect/AnimationPlayer.play("goToMain")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	GlobalVar.playedTutorial = true
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

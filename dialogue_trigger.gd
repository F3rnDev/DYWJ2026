extends Node3D

class_name DialogueTrigger

@onready var dialogue_ui = get_tree().current_scene.get_node("UI/DialogueUI/Canvas")
@onready var dialogue_action:Label = get_tree().current_scene.get_node("UI/DialogueUI/Canvas/Action")
@onready var dialogue_text: RichTextLabel = get_tree().current_scene.get_node("UI/DialogueUI/Canvas/DialogueText")
@onready var dialogue_animation: AnimationPlayer = get_tree().current_scene.get_node("UI/DialogueUI/Canvas/AnimationPlayer")

@export_multiline() var dialogues: Array[String]
@export var offActionsId:Array[int] = [5, 9, 13, 20, 26, 28]

var cantSkip = false
var current_dialogue = -1
var started = false

signal endedDialogue

func start_dialogue():
	started = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	dialogue_ui.visible = true
		
	continue_dialogue()

func end_dialogue():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	dialogue_ui.visible = false
	
	endedDialogue.emit()

func continue_dialogue():
	current_dialogue += 1
	
	if current_dialogue in offActionsId:
		cantSkip = true
	else:
		cantSkip = false
	
	dialogue_action.visible = !cantSkip
	
	if current_dialogue < dialogues.size():
		dialogue_text.text = dialogues[current_dialogue]
		dialogue_animation.play("RESET")
		dialogue_animation.play("scroll")
	else:
		end_dialogue()

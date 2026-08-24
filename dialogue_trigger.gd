extends Node3D


@onready var dialogue_ui = get_tree().current_scene.get_node("UI/DialogueUI/Canvas")
@onready var dialogue_text: RichTextLabel = get_tree().current_scene.get_node("UI/DialogueUI/Canvas/DialogueText")
@onready var dialogue_animation: AnimationPlayer = get_tree().current_scene.get_node("UI/DialogueUI/Canvas/AnimationPlayer")
@onready var player: CharacterBody3D = get_tree().current_scene.get_node("CharacterBody3D")
@export var speaker: Node3D

@export_multiline() var dialogues: Array[String]


var current_dialogue = -1
var started = false

func start_dialogue(body):
	if body == player and !started:
		started = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.SPEED = 0.0
		player.camSens = 0.0
		dialogue_ui.visible = true
		
		player.look_at(speaker.global_transform.origin)
		player.rotation_degrees.x = 0
		player.rotation_degrees.z = 0
		continue_dialogue()

func end_dialogue():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.SPEED = 5.0
	player.camSens = 50
	dialogue_ui.visible = false

func continue_dialogue():
	current_dialogue += 1
	if current_dialogue < dialogues.size():
		dialogue_text.text = dialogues[current_dialogue]
		dialogue_animation.play("RESET")
		dialogue_animation.play("scroll")
	else:
		end_dialogue()

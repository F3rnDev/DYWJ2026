extends Label3D

class_name pointAddUI

var range = 0.5

func create(value) -> void:
	text = "+" + str(value)
	$AnimationPlayer.play("spawn")
	
	var arcTween = create_tween()
	arcTween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	arcTween.tween_property(self, "position:x", getRandomX(), 1.0)

func getRandomX():
	return randf_range(-range, range)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()

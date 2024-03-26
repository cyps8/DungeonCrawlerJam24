extends Area3D

func _ready():
	var beatTween: Tween = create_tween().set_loops()
	beatTween.tween_interval(1)
	beatTween.tween_property($Sprite, "scale", Vector3(1.1, 1.1, 1.1), 0.01)
	beatTween.tween_property($Sprite, "scale", Vector3(1.0, 1.0, 1.0), 0.5)

	var floatTween: Tween = create_tween().set_loops()
	floatTween.tween_property($Sprite, "position", Vector3(0, 0.05, 0), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	floatTween.tween_property($Sprite, "position", Vector3(0, 0, 0), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
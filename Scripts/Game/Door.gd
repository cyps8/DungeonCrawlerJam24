extends AnimatableBody3D

var opened = false

func Interact(_tile: MapTile):
	if opened:
		return
	opened = true
	
	$Shape.position.y += 2

	var openTween = create_tween()
	openTween.tween_property($Mesh, "position:y", position.y + 2, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	Level.instance.ExpandMap(_tile)
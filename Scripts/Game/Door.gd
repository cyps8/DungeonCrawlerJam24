extends AnimatableBody3D

var opened = false

@export var itemRequired: Item

func Interact(_tile: MapTile):
	if opened:
		return

	if itemRequired != null:
		if GameManager.instance.invRef.HasItem(itemRequired):
			GameManager.instance.hudRef.ShowHint(itemRequired.name + " was used to open the door")
		else:
			GameManager.instance.hudRef.ShowHint("You need a " + itemRequired.name + " to open the door")
			return

	opened = true
	
	$Shape.position.y += 2

	var openTween = create_tween()
	openTween.tween_property($Mesh, "position:y", position.y + 2, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	Level.instance.ExpandMap(_tile)
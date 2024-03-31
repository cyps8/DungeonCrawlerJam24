extends StaticBody3D

var opened = false

@export var items: Array[Item] = []

func Interact(_tile: MapTile):
	if opened:
		GameManager.instance.hudRef.ShowHint("Container already opened...")
		return
	opened = true
	GameManager.instance.hudRef.ShowHint("Container opened")
	var openTween: Tween = create_tween()
	openTween.tween_property($Mesh/Hinge, "rotation:y", deg_to_rad(-30), 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	for item in items:
		GameManager.instance.invRef.AddItem(item)
		GameManager.instance.hudRef.AddAction(item.name + " added to inventory", item.icon)

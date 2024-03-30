extends StaticBody3D

var opened = false

@export var items: Array[Item] = []

func Interact(_tile: MapTile):
	if opened:
		GameManager.instance.hudRef.ShowHint("Container already opened...")
		return
	opened = true
	GameManager.instance.hudRef.ShowHint("Container opened")
	for item in items:
		GameManager.instance.invRef.AddItem(item)
		GameManager.instance.hudRef.AddAction(item.name + " added to inventory", item.icon)

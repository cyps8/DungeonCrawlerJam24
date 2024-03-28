extends StaticBody3D

var opened = false

@export var items: Array[Item] = []

func Interact(_tile: MapTile):
	if opened:
		return
	opened = true
	
	for item in items:
		GameManager.instance.invRef.AddItem(item)

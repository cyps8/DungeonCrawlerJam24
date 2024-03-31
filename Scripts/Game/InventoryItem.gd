extends MenuButton

class_name InventoryItem

var item: Item
var count: int = 0

func _ready():
	get_popup().id_pressed.connect(Used)

func changeCount(deltaCount: int):
	count += deltaCount
	if count > 1:
		$Label.text = item.name +  " (" + str(count) + ")"
	else:
		$Label.text = item.name

func SetIcon(texture: Texture2D):
	$Img.texture = texture

func Used(_id: int = 0):
	GameManager.instance.ChangeStat(item.type, item.value, item.function)
	GameManager.instance.invRef.RemoveItem(item)
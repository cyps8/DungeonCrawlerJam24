extends CanvasLayer

class_name Inventory

@export var itemIns: PackedScene

var items: Array[InventoryItem] = []

@export var defaultInv: Array[Item] = []

func _ready():
	for item in defaultInv:
		AddItem(item)

func AddItem(addItem: Item) -> void:
	for item in items:
		if item.item == addItem:
			item.changeCount(1)
			return

	var newItem: InventoryItem = itemIns.instantiate()
	newItem.item = addItem
	items.append(newItem)
	%Items.add_child(newItem)
	newItem.changeCount(1)

func RemoveItem(removeItem: InventoryItem) -> void:
	for item in items:
		if item == removeItem:
			item.changeCount(-1)
			if item.count == 0:
				items.erase(item)
				removeItem.queue_free()
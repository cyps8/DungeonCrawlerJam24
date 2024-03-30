extends CanvasLayer

class_name Inventory

@export var itemIns: PackedScene

@export var objectiveIns: PackedScene

var items: Array[InventoryItem] = []

@export var defaultInv: Array[Item] = []

@onready var itemsRef = %Items

@onready var healthBarRef = %HealthBar
@onready var sanityBarRef = %SanityBar
@onready var objectiveListRef = %Objectives

func _ready():
	for item in defaultInv:
		AddItem(item)

func UpdateHealth(value: float):
	healthBarRef.value = value

func UpdateSanity(value: float):
	sanityBarRef.value = value

func AddObjective(msg: String, completeSignal: Signal):
	var newObjective = objectiveIns.instantiate()
	newObjective.text = "• " + msg
	completeSignal.connect(newObjective.queue_free)
	objectiveListRef.add_child(newObjective)


func AddItem(addItem: Item) -> void:
	for item in items:
		if item.item == addItem:
			item.changeCount(1)
			return

	var newItem: InventoryItem = itemIns.instantiate()
	newItem.item = addItem
	newItem.tooltip_text = addItem.description
	if addItem.consumable:
		newItem.disabled = false
	items.append(newItem)
	itemsRef.add_child(newItem)
	newItem.changeCount(1)

func TryQuickReload():
	for item in items:
		if item.item.name == "Battery":
			item.Used()
			return
	GameManager.instance.hudRef.ShowHint("Out of batteries")
			
func RemoveItem(removeItem: Item) -> void:
	for item in items:
		if item.item == removeItem:
			item.changeCount(-1)
			if item.count == 0:
				items.erase(item)
				item.queue_free()

func HasItem(item: Item) -> bool:
	for i in items:
		if i.item == item:
			return true
	return false

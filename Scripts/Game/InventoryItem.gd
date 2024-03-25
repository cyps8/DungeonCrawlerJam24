extends Node

class_name InventoryItem

var item: Item
var count: int = 0

func changeCount(deltaCount: int):
    count += deltaCount
    if count > 1:
        $Label.text = item.name +  " (" + str(count) + ")"
    else:
        $Label.text = item.name
    
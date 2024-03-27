extends Resource

class_name Item

enum Function {
    ChangeValue,
    ChangeMax,
    SetPercentage
}

enum Type {
    Health,
    Sanity,
    Battery
}

@export var name: String = "Item_Name"
@export var icon: Texture = null
@export var description: String = "Item_Description"
@export var consumable: bool = false

@export_category("If consumable:")
@export var type: Type
@export var function: Function
@export var value: int = 0

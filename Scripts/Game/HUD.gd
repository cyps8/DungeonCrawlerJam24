extends CanvasLayer

class_name HUD

var batteryCharge: TextureProgressBar

var hintLabel: Label

var hintTween: Tween

var controlsLabel: Label

var actionsList: VBoxContainer

@export var actionIns: PackedScene

func _ready():
    batteryCharge = $Border/BatteryCharge
    hintLabel = $Border/Hint
    controlsLabel = $Border/Controls
    actionsList = $Border/ActionList
    hintLabel.modulate.a = 0

func UpdateBatteryCharge(value):
    batteryCharge.value = value

func ShowHint(hint: String):
    hintLabel.text = hint
    hintLabel.modulate.a = 1

    if hintTween != null:
        hintTween.kill()
    hintTween = create_tween()
    hintTween.tween_property(hintLabel, "modulate:a", 0, 2)

func UpdateControls(msg: String):
    controlsLabel.text = msg

func AddAction(action: String, texture: Texture2D = null):
    var newAction = actionIns.instantiate()
    newAction.SetText(action)
    newAction.SetTexture(texture)
    actionsList.add_child(newAction)
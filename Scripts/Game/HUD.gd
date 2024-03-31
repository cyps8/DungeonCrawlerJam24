extends CanvasLayer

class_name HUD

var batteryCharge: TextureProgressBar

var hintLabel: Label

var hintTween: Tween

var controlsLabel: Label

var actionsList: VBoxContainer

@export var actionIns: PackedScene

var flashlightOn: TextureRect
var flashlightOff: TextureRect

func _ready():
    batteryCharge = $Border/BatteryCharge
    hintLabel = $Border/Hint
    controlsLabel = $Border/Controls
    actionsList = $Border/ActionList
    flashlightOn = $Border/FlashlightOn
    flashlightOff = $Border/FlashlightOff
    hintLabel.modulate.a = 0

    flashlightOn.visible = false
    flashlightOff.visible = true

    UpdateBatteryCharge(1)

func UpdateBatteryCharge(value):
    batteryCharge.value = value
    batteryCharge.modulate = lerp(Color(1, 0, 0, 1), Color(0, 1, 0, 1), value)

func UpdateFlashlightState(on: bool):
    if on:
        flashlightOn.visible = true
        flashlightOff.visible = false
    else:
        flashlightOn.visible = false
        flashlightOff.visible = true

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
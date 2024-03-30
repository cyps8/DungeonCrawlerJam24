extends CanvasLayer

class_name FightHUD

var bothBars: Control

var frontBar: ProgressBar

var backBar: ProgressBar

var backBarTween: Tween

var pulseTween: Tween

func _ready():
	bothBars = $Bars
	frontBar = $Bars/HealthBar
	backBar = $Bars/HealthBarBack

func UpdateHealth(value: float):
	frontBar.value = value
	if backBar.value < value:
		backBar.value = value
	else:
		if backBarTween != null:
			backBarTween.kill()
		if is_inside_tree():
			backBarTween = create_tween()
			backBarTween.tween_interval(0.5)
			backBarTween.tween_property(backBar, "value", value, 0.5)

	if is_inside_tree():
		pulseTween = create_tween()
		pulseTween.tween_property(bothBars, "scale", Vector2(1.1, 1.1), 0.01)
		pulseTween.tween_property(bothBars, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _exit_tree():
	if backBarTween != null:
		backBarTween.kill()
	backBar.value = frontBar.value

	if pulseTween != null:
		pulseTween.kill()
	bothBars.scale = Vector2(1, 1)
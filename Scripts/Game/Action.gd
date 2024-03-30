extends Control

func _ready():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)

func SetText(msg: String):
	$Label.text = msg

func SetTexture(texture: Texture2D = null):
	if texture == null:
		$Sprite.visible = false
	$Sprite.texture = texture
extends Area3D

class_name FightAttack

var speed: float = 0.008

var defeated: bool = false

func _ready():
	var tween: Tween = create_tween().set_loops()
	tween.tween_interval(0.3)
	tween.tween_callback(Flip)

func Flip():
	$Sprite.flip_h = !$Sprite.flip_h

func _process(_delta):
	if !defeated:
		position = position.move_toward(Vector3(0, 0.25, 0), speed)
	else:
		position = position.move_toward(Vector3(0, -0.25, 0), -speed * 8)
		if position.distance_to(Vector3(0, -0.25, 0)) > 6:
			Fight.instance.activeAttacks.remove_at(Fight.instance.activeAttacks.find(self))
			queue_free()

func Defeated(_body):
	_body.Burst()
	defeated = true

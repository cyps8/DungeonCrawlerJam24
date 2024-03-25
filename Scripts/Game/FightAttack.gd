extends Area3D

class_name FightAttack

var speed: float = 0.01

var defeated: bool = false

func _process(_delta):
	if !defeated:
		position = position.move_toward(Vector3(0, 0.25, 0), speed)
	else:
		position = position.move_toward(Vector3(0, -0.25, 0), -speed * 5)
		if position.distance_to(Vector3(0, -0.25, 0)) > 6:
			Fight.instance.activeAttacks.remove_at(Fight.instance.activeAttacks.find(self))
			queue_free()

func Defeated(_body):
	defeated = true

extends Area3D

@export var heartBurst: PackedScene

var particles: Array[GPUParticles3D] = []

var tweens: Array[Tween] = []

func _ready():
	var beatTween: Tween = create_tween().set_loops()
	beatTween.tween_interval(0.5)
	beatTween.tween_property($Sprite, "scale", Vector3(1.1, 1.1, 1.1), 0.01)
	beatTween.tween_property($Sprite, "scale", Vector3(1.0, 1.0, 1.0), 0.15)

	var floatTween: Tween = create_tween().set_loops()
	floatTween.tween_property($Sprite, "position", Vector3(0, 0.05, 0), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	floatTween.tween_property($Sprite, "position", Vector3(0, 0, 0), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func KnifeHurt(_body):
	GameManager.instance.ChangeHealth(-10)
	var kb = _body.position
	kb.y = 0
	kb = kb.normalized() * 5
	_body.velocity = kb
	HurtAnim(_body.position)
	_body.PlayerReact()

func EnemyHurt(dmg: int, dir: Vector3):
	GameManager.instance.ChangeHealth(-dmg)
	HurtAnim(dir)

func HurtAnim(dir: Vector3):
	dir.y = 0
	dir = dir.normalized()

	AudioPlayer.instance.PlaySound(6, AudioPlayer.SoundType.SFX)

	var newParticles: GPUParticles3D = heartBurst.instantiate()
	newParticles.position = dir * 0.2
	newParticles.process_material.direction = Vector3(dir.x, 1, dir.z)
	newParticles.emitting = true
	add_child(newParticles)
	particles.append(newParticles)

	var hurtTween: Tween = create_tween().set_loops(2)
	hurtTween.tween_callback(ChangeColor.bind(Color(236.0/255.0, 106.0/255.0, 110.0/255.0)))
	hurtTween.tween_interval(0.05)
	hurtTween.tween_callback(ChangeColor.bind(Color(1,1,1)))
	hurtTween.tween_interval(0.05)
	tweens.append(hurtTween)

	var hurtExpandTween: Tween = create_tween()
	hurtExpandTween.tween_property($Sprite, "scale", Vector3(1.3, 1.3, 1.3), 0.02)
	hurtExpandTween.tween_property($Sprite, "scale", Vector3(1.0, 1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tweens.append(hurtExpandTween)

func ChangeColor(color: Color):
	$Sprite.modulate = color

func _exit_tree():
	for p in particles:
		p.queue_free()
	particles.clear()
	
	for tween in tweens:
		tween.kill()
	tweens.clear()
	ChangeColor(Color(1,1,1))
	$Sprite.scale = Vector3(1.0, 1.0, 1.0)
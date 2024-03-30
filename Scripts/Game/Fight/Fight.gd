extends Node3D

class_name Fight

static var instance: Fight

@export var attackList: Array[PackedScene]

var activeAttacks: Array[FightAttack] = []

var attackQueue: Array[float] = []

var fightTimer: float = 0

var ended = false

var hudRef: FightHUD

var gameOverRef: CanvasLayer

var endTween: Tween

func _init():
	instance = self

func _ready():
	gameOverRef = $GameOver
	gameOverRef.visible = true
	remove_child(gameOverRef)
	hudRef = $FightHUD

func GameOver():
	if ended:
		return
	ended = true
	if endTween != null:
		endTween.kill()
	add_child(gameOverRef)

func _process(_delta):
	if ended:
		return
	fightTimer += _delta
	if attackQueue.size() > 0:
		if attackQueue[0] <= fightTimer:
			SpawnAttack()
			attackQueue.pop_front()
	elif activeAttacks.size() == 0:
		ended = true
		endTween = create_tween()
		endTween.tween_interval(1)
		endTween.tween_callback(GameManager.instance.SwitchToLevel)

func StartFight():
	ended = false
	%FightPlayer.position = Vector3(0, 0.25, 1)
	%FightPlayer.get_node("Sprite").rotation.y = 0
	fightTimer = 0
	attackQueue.append(0.0)
	attackQueue.append(0.3)
	attackQueue.append(0.6)
	attackQueue.append(0.8)

func SpawnAttack():
	var newAttack = attackList[randi() % attackList.size()].instantiate()
	add_child(newAttack)
	newAttack.rotation.y = randf() * 2 * PI
	newAttack.position = Vector3(0, 0.25, 7).rotated(Vector3.UP, newAttack.rotation.y)
	while Near(newAttack.position):
		newAttack.rotation.y = randf() * 2 * PI
		newAttack.position = Vector3(0, 0.25, 7).rotated(Vector3.UP, newAttack.rotation.y)
	activeAttacks.append(newAttack)

func Near(pos: Vector3) -> bool:
	for attack in activeAttacks:
		if pos.distance_to(attack.position) < 3:
			return true
	return false
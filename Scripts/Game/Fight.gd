extends Node3D

class_name Fight

static var instance: Fight

@export var attackList: Array[PackedScene]

var activeAttacks: Array[FightAttack] = []

func _init():
	instance = self

func _process(_delta):
	if activeAttacks.size() == 0:
		GameManager.instance.SwitchToLevel()

func StartFight():
	SpawnAttack()

func SpawnAttack():
	var newAttack = attackList[randi() % attackList.size()].instantiate()
	add_child(newAttack)
	newAttack.position = Vector3(0, 0.25, 7)
	activeAttacks.append(newAttack)
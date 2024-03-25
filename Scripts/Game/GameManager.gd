extends Node

class_name GameManager
static var instance: GameManager

var levelRef: Level
var fightRef: Fight

var pauseRef: PauseMenu
var paused: bool = false

var hudRef: HUD
var invRef: Inventory

var invOpen: bool = false

func _ready():
	pauseRef = $Pause
	pauseRef.visible = true
	remove_child(pauseRef)

	hudRef = $HUD
	hudRef.visible = true
	invRef = $Inventory
	invRef.visible = true
	remove_child(invRef)

	levelRef = $Level
	levelRef.visible = true
	fightRef = $Fight
	fightRef.visible = true
	remove_child(fightRef)

	SwitchToFight()

	instance = self

	Level.instance.MapGenerated.connect(OnMapGenerated)

func SwitchToLevel():
	remove_child(fightRef)
	add_child(levelRef)
	add_child(hudRef)

func SwitchToFight():
	remove_child(levelRef)
	remove_child(hudRef)
	if invOpen:
		invOpen = false
		remove_child(invRef)
	add_child(fightRef)

func OnMapGenerated():
	Level.instance.SpawnNewEnemy()
	Level.instance.SpawnNewEnemy()
	Level.instance.SpawnNewEnemy()

func ToggleInventory():
	invOpen = !invOpen
	if invOpen:
		add_child(invRef)
	else:
		remove_child(invRef)

func TogglePause():
	paused = !paused
	if paused:
		get_tree().paused = true
		add_child(pauseRef)
	else:
		get_tree().paused = false
		remove_child(pauseRef)

func _process(_delta):
	if Input.is_action_just_pressed("Inventory") && !paused:
		ToggleInventory()
	if Input.is_action_just_pressed("Pause") && !SceneManager.instance.optionsOpen:
		TogglePause()
	elif Input.is_action_just_pressed("ui_cancel") && !SceneManager.instance.optionsOpen && paused:
		TogglePause()
	

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

var sanity: float = 100.0
var sanityMax: float = 100.0

var health: float = 100.0
var healthMax: float = 100.0

var flBatteryLevel: float
var flBatteryMax: float = 60

var playerRef: Player
var gameOver: bool = false

var activeEnemies: Array[Enemy] = []

var hasFuel = false
var powerFixed = false

func _ready():
	flBatteryLevel = flBatteryMax

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

	instance = self

	playerRef = get_tree().get_first_node_in_group("Player")
	endInteractable = get_tree().get_first_node_in_group("End")

	Level.instance.MapGenerated.connect(OnMapGenerated)
	fightRef.hudRef.UpdateHealth(health/healthMax)

	AudioPlayer.instance.PlaySound(8, AudioPlayer.SoundType.SFX)

var endInteractable: StaticBody3D
	
var endObj = false

func ManageEnemies():
	if playerRef.inLight:
		for enemy in activeEnemies:
			enemy.queue_free()
		activeEnemies.clear()
	else:
		if activeEnemies.size() < 1 && sanity < 75:
			activeEnemies.append(Level.instance.SpawnNewEnemy())
		elif activeEnemies.size() < 2 && sanity < 50:
			activeEnemies.append(Level.instance.SpawnNewEnemy())
		elif activeEnemies.size() < 3 && sanity < 25:
			activeEnemies.append(Level.instance.SpawnNewEnemy())
		if activeEnemies.size() > 2 && sanity > 25:
			activeEnemies[0].queue_free()
			activeEnemies.remove_at(0)
		elif activeEnemies.size() > 1 && sanity > 50:
			activeEnemies[0].queue_free()
			activeEnemies.remove_at(0)
		elif activeEnemies.size() > 0 && sanity > 75:
			activeEnemies[0].queue_free()
			activeEnemies.remove_at(0)

func ChangeHealth(value):
	health += value
	health = clamp(health, 0, healthMax)
	invRef.UpdateHealth(health/ healthMax)
	fightRef.hudRef.UpdateHealth(health/healthMax)
	if health == 0:
		fightRef.GameOver()
		gameOver = true

func ChangeSanity(value):
	sanity += value
	sanity = clamp(sanity, 0, sanityMax)
	invRef.UpdateSanity(sanity/ sanityMax)

func ChangeBattery(value):
	flBatteryLevel += value
	flBatteryLevel = clamp(flBatteryLevel, 0, flBatteryMax)
	hudRef.UpdateBatteryCharge(flBatteryLevel / flBatteryMax)

func ChangeBatteryMax(value):
	flBatteryLevel = (flBatteryLevel / flBatteryMax) * (flBatteryMax + value)
	flBatteryMax += value
	hudRef.UpdateBatteryCharge(flBatteryLevel / flBatteryMax)

func ChangeHealthMax(value):
	healthMax = (healthMax / healthMax) * (healthMax + value)
	healthMax += value
	invRef.UpdateHealth(health/ healthMax)
	fightRef.hudRef.UpdateHealth(health/healthMax)

func ChangeSanityMax(value):
	sanityMax = (sanityMax / sanityMax) * (sanityMax + value)
	sanityMax += value
	invRef.UpdateSanity(sanity/ sanityMax)

func SetHealth(value):
	health = value
	health = clamp(health, 0, healthMax)
	invRef.UpdateHealth(health/ healthMax)
	fightRef.hudRef.UpdateHealth(health/healthMax)

func SetSanity(value):
	sanity = value
	sanity = clamp(sanity, 0, sanityMax)
	invRef.UpdateSanity(sanity/ sanityMax)

func SetBattery(value):
	flBatteryLevel = value
	flBatteryLevel = clamp(flBatteryLevel, 0, flBatteryMax)
	hudRef.UpdateBatteryCharge(flBatteryLevel / flBatteryMax)

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
	fightRef.StartFight()

func OnMapGenerated():
	pass

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
	if gameOver:
		return
	if hasFuel && powerFixed && !endObj:
		endInteractable.AddObj()
		endObj = true

	ManageEnemies()
	if Input.is_action_just_pressed("DebugSpawnEnemy"):
		SwitchToFight()
	if Input.is_action_just_pressed("Reload"):
		ReloadBattery()
	if Input.is_action_just_pressed("Inventory") && !paused:
		ToggleInventory()
	if Input.is_action_just_pressed("Pause") && !SceneManager.instance.optionsOpen:
		TogglePause()
	elif Input.is_action_just_pressed("ui_cancel") && !SceneManager.instance.optionsOpen && paused:
		TogglePause()
	
func ReloadBattery():
	invRef.TryQuickReload()

func ChangeStat(type: Item.Type, value: float, function: Item.Function):
	match type:
		Item.Type.Health:
			match function:
				Item.Function.ChangeValue:
					ChangeHealth(value)
				Item.Function.ChangeMax:
					ChangeHealthMax(value)
				Item.Function.SetPercentage:
					SetHealth((value/100) * healthMax)
		Item.Type.Sanity:
			match function:
				Item.Function.ChangeValue:
					ChangeSanity(value)
				Item.Function.ChangeMax:
					ChangeSanityMax(value)
				Item.Function.SetPercentage:
					SetSanity((value/100) * sanityMax)
		Item.Type.Battery:
			match function:
				Item.Function.ChangeValue:
					ChangeBattery(value)
				Item.Function.ChangeMax:
					ChangeBatteryMax(value)
				Item.Function.SetPercentage:
					SetBattery((value/100) * flBatteryMax)

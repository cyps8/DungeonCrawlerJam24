extends Node3D

class_name Player

var forward: Vector3 = Vector3.FORWARD

var turnSpeed: float = 5

var moveSpeed: float = 5

var moving: bool = false

var flOn: bool = false

var canMove: bool = false

var currentTile: MapTile
var currentDirection: Level.Side

var camRef: Camera3D
var flashlightRef: SpotLight3D

func _ready():
	Level.instance.MapGenerated.connect(JoinMap)

	camRef = $Cam
	flashlightRef = $Cam/Flashlight
	camRef.remove_child(flashlightRef)

	forward = forward.rotated(Vector3.UP, rotation.y)
	if rotation_degrees.y == 0:
		currentDirection = Level.Side.North
	elif rotation_degrees.y == -90:
		currentDirection = Level.Side.East
	elif rotation_degrees.y == 180 || rotation_degrees.y == -180:
		currentDirection = Level.Side.South
	else:
		currentDirection = Level.Side.West

func JoinMap():
	canMove = true
	currentTile = Level.instance.Map[0]
	position = currentTile.position + Vector3(0, Level.instance.blockSize / 2, 0)

func _process(_delta):
	if Input.is_action_just_pressed("TurnL"):
		TryRotate(1)
	if Input.is_action_just_pressed("TurnR"):
		TryRotate(-1)
	if Input.is_action_just_pressed("Forward"):
		TryMove(currentDirection)
	if Input.is_action_just_pressed("Back"):
		TryMove(GetSideTurned(currentDirection, 2))
	if Input.is_action_just_pressed("Left"):
		TryMove(GetSideTurned(currentDirection, -1))
	if Input.is_action_just_pressed("Right"):
		TryMove(GetSideTurned(currentDirection, 1))
	if Input.is_action_just_pressed("Interact"):
		Interact()
	TryInteract()

	if Input.is_action_just_pressed("ToggleFlashlight") && GameManager.instance.flBatteryLevel > 0:
		flOn = !flOn
		if flOn:
			camRef.add_child(flashlightRef)
		else:
			camRef.remove_child(flashlightRef)

	if inLight:
		GameManager.instance.ChangeSanity(+_delta * 5)
	else:
		GameManager.instance.ChangeSanity(-_delta / 1.5)

	if flOn:
		GameManager.instance.ChangeBattery(-_delta)
		if GameManager.instance.flBatteryLevel <= 0:
			GameManager.instance.flBatteryLevel = 0
			camRef.remove_child(flashlightRef)
			flOn = false

	GameManager.instance.hudRef.UpdateFlashlightState(flOn)

func TryMove(direction: Level.Side):
	if moving || !canMove:
		return
	if currentTile.sides[direction] != null:
		currentTile = currentTile.sides[direction]
		var tween = create_tween()
		moving = true
		tween.tween_method(SetPlayerPosition, position, currentTile.position, 1 / moveSpeed)
		tween.tween_callback(EndMove)

func TryRotate(direction: float):
	if moving || !canMove:
		return
	currentDirection = GetSideTurned(currentDirection, -int(direction))
	forward = forward.rotated(Vector3.UP, direction * 90 * PI / 180)
	var tween = create_tween()
	moving = true
	tween.tween_property(self, "rotation_degrees:y", rotation_degrees.y + (90 * direction), 1 / turnSpeed)
	tween.tween_callback(EndMove)

func EndMove():
	moving = false

	if Input.is_action_pressed("TurnL"):
		TryRotate(1)
	if Input.is_action_pressed("TurnR"):
		TryRotate(-1)
	if Input.is_action_pressed("Forward"):
		TryMove(currentDirection)
	if Input.is_action_pressed("Back"):
		TryMove(GetSideTurned(currentDirection, 2))
	if Input.is_action_pressed("Left"):
		TryMove(GetSideTurned(currentDirection, -1))
	if Input.is_action_pressed("Right"):
		TryMove(GetSideTurned(currentDirection, 1))

func SetPlayerPosition(pos: Vector3):
	position.x = pos.x
	position.z = pos.z
	position.y = Level.instance.RayGetFloorHeight(position) + 1

func GetSideTurned(current: int, amount: int) -> Level.Side:
	current += amount
	if current > 3:
		current -= 4
	if current < 0:
		current += 4
	return current as Level.Side

func Interact():
	var space_state = get_world_3d().direct_space_state
	var origin = position
	var end = position + (forward * 2)
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)
	if result:
		if result["collider"].is_in_group("Interactable"):
			result["collider"].Interact(currentTile)

func TryInteract():
	var space_state = get_world_3d().direct_space_state
	var origin = position
	var end = position + (forward * 2)
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)
	if result:
		if result["collider"].is_in_group("Interactable"):
			GameManager.instance.hudRef.UpdateControls("PRESS 'SPACE' TO INTERACT")
		else:
			GameManager.instance.hudRef.UpdateControls("")
	else:
		GameManager.instance.hudRef.UpdateControls("")

var inLights = 0

var inLight: bool = false

func AreaExit(area: Area3D):
	if area.is_in_group("Light"):
		inLights -= 1
		if inLights == 0:
			InDarkness()

func AreaEnter(area:Area3D):
	if area.is_in_group("Light"):
		inLights += 1
		if inLights > 0:
			InLight()

func InLight():
	inLight = true

func InDarkness():
	inLight = false

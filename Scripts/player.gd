extends Node3D

var forward: Vector3 = Vector3.FORWARD

var turnSpeed: float = 5

var moveSpeed: float = 5

var moving: bool = false

var blockSize: float = 2

func _process(_delta):
	if !moving:
		if Input.is_action_just_pressed("Forward"):
			TryMove(forward * blockSize)
		if Input.is_action_just_pressed("Back"):
			TryMove(-forward * blockSize)
		if Input.is_action_just_pressed("Left"):
			TryMove(forward.rotated(Vector3.UP, PI/2) * blockSize)
		if Input.is_action_just_pressed("Right"):
			TryMove(forward.rotated(Vector3.UP, -PI/2) * blockSize)
		if Input.is_action_just_pressed("TurnL"):
			TryRotate(1)
		if Input.is_action_just_pressed("TurnR"):
			TryRotate(-1)
		if Input.is_action_just_pressed("Interact"):
			Interact()

	if Input.is_action_just_pressed("ToggleFlashlight"):
		$Cam/Flashlight.visible = !$Cam/Flashlight.visible

func TryMove(direction: Vector3):
	if !RayDirectionCheck(direction) && RayDirectionFloorHeight(direction):
		var tween = create_tween()
		moving = true
		tween.tween_method(SetPlayerPosition, position, position + direction, 1 / moveSpeed)
		tween.tween_callback(EndMove)

func TryRotate(direction: float):
	forward = forward.rotated(Vector3.UP, direction * 90 * PI / 180)
	var tween = create_tween()
	moving = true
	tween.tween_property(self, "rotation_degrees:y", rotation_degrees.y + (90 * direction), 1 / turnSpeed)
	tween.tween_callback(EndMove)

func EndMove():
	moving = false

func SetPlayerPosition(pos: Vector3):
	position.x = pos.x
	position.z = pos.z
	position.y = RayGetCurrentFloorHeight() + 1

func RayDirectionCheck(direction: Vector3) -> bool:
	var space_state = get_world_3d().direct_space_state

	var origin = position
	var end = position + direction + Vector3(0, 0.1, 0)
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	var result = space_state.intersect_ray(query)
	if result:
		return true
	else:
		return false

func RayGetCurrentFloorHeight() -> float:
	var space_state = get_world_3d().direct_space_state

	var origin = position
	var end = position + Vector3.DOWN * blockSize
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	var result = space_state.intersect_ray(query)
	if result:
		return result["position"].y
	else:
		return -999

func RayDirectionFloorHeight(direction: Vector3) -> float:
	var space_state = get_world_3d().direct_space_state

	var origin = position + direction + Vector3(0, 0.1, 0)
	var end = position + direction + (Vector3.DOWN * blockSize) + Vector3(0, -0.1, 0)
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	var result = space_state.intersect_ray(query)
	if result:
		return true
	else:
		return false

func Interact():
	var space_state = get_world_3d().direct_space_state
	var origin = position
	var end = position + forward
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)
	if result:
		if result["collider"].is_in_group("Interactable"):
			result["collider"].queue_free()

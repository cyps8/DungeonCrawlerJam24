extends Node3D

var forward: Vector3 = Vector3.FORWARD

var turnSpeed: float = 5

var moveSpeed: float = 5

func _process(_delta):
	if Input.is_action_just_pressed("Forward"):
		TryMove(forward)
	if Input.is_action_just_pressed("Back"):
		TryMove(-forward)
	if Input.is_action_just_pressed("Left"):
		TryMove(forward.rotated(Vector3.UP, PI/2))
	if Input.is_action_just_pressed("Right"):
		TryMove(forward.rotated(Vector3.UP, -PI/2))
	if Input.is_action_just_pressed("TurnL"):
		var tween = create_tween()
		tween.tween_property(self, "rotation_degrees:y", rotation_degrees.y + 90, 1 / turnSpeed)
		forward = forward.rotated(Vector3.UP, PI/2)
	if Input.is_action_just_pressed("TurnR"):
		var tween = create_tween()
		tween.tween_property(self, "rotation_degrees:y", rotation_degrees.y - 90, 1 / turnSpeed)
		forward = forward.rotated(Vector3.UP, -PI/2)

func TryMove(direction: Vector3):
	if !RayDirectionCheck(direction) && RayDirectionFloorHeight(direction):
		var tween = create_tween()
		tween.tween_method(SetPlayerPosition, position, position + direction, 1 / moveSpeed)

func SetPlayerPosition(pos: Vector3):
	position.x = pos.x
	position.z = pos.z
	position.y = RayGetCurrentFloorHeight() + 0.5

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
	var end = position + Vector3.DOWN
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	var result = space_state.intersect_ray(query)
	if result:
		return result["position"].y
	else:
		return -999

func RayDirectionFloorHeight(direction: Vector3) -> float:
	var space_state = get_world_3d().direct_space_state

	var origin = position + direction + Vector3(0, 0.1, 0)
	var end = position + direction + Vector3.DOWN + Vector3(0, -0.1, 0)
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	var result = space_state.intersect_ray(query)
	if result:
		return true
	else:
		return false
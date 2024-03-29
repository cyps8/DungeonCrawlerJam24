extends Node3D

class_name Level
static var instance: Level

enum Side {
	North = 0,
	East = 1,
	South = 2,
	West = 3
}

var Map: Array[MapTile] = []

var TilesToCheck: Array[MapTile] = []

var blockSize: float = 2

signal MapGenerated

@export var startPoint: Vector3 = Vector3(-1, 1, 1)

@export var enemyList: Array[PackedScene]

func _init():
	instance = self

func _ready():
	# Timer is a workaround as otherwise the map collision is not generated before the map is generated
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.01
	timer.one_shot = true
	timer.start()
	timer.timeout.connect(GenerateMap.bind(startPoint))
	timer.timeout.connect(timer.queue_free)

func GenerateMap(startPos: Vector3):
	var tile = MapTile.new()
	tile.position = startPos
	tile.position.y = RayGetFloorHeight(tile.position)
	Map.append(tile)
	TilesToCheck.append(tile)

	while TilesToCheck.size() > 0:
		CheckTiles()
	print ("Map generated with " + str(Map.size()) + " tiles")
	emit_signal("MapGenerated")

func ExpandMap(startTile: MapTile):
	TilesToCheck.append(startTile)

	while TilesToCheck.size() > 0:
		CheckTiles()
	print ("Map expanded to " + str(Map.size()) + " tiles")

func CheckTiles():
	var tile = TilesToCheck[0]
	tile.sides[Side.North] = TestDirection(tile.position, Vector3.FORWARD)
	tile.sides[Side.East] = TestDirection(tile.position, Vector3.RIGHT)
	tile.sides[Side.South] = TestDirection(tile.position, Vector3.BACK)
	tile.sides[Side.West] = TestDirection(tile.position, Vector3.LEFT)
	TilesToCheck.remove_at(0)

func TestDirection(pos: Vector3, direction: Vector3) -> MapTile:
	var normal = GetFloorNormal(pos)
	# Make direction parrarel to normal plane
	direction = direction - normal * normal.dot(direction)
	direction *= 1 / Vector3(direction.x, 0, direction.z).length()
	direction *= blockSize

	if !RayDirectionCheck(pos, direction) && RayDirectionCheckFloor(pos, direction):
		var newPosition: Vector3 = pos + direction
		newPosition.y = RayGetFloorHeight(newPosition)
		for tile in Map:
			if tile.position == newPosition:
				return tile
		var newTile = MapTile.new()
		newTile.position = newPosition
		Map.append(newTile)
		TilesToCheck.append(newTile)
		return newTile
	return null

func GetFloorNormal(pos: Vector3) -> Vector3:
	var space_state = get_world_3d().direct_space_state

	var origin = pos + (Vector3.UP * 1.1)
	var end = pos + Vector3.DOWN * blockSize
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	var result = space_state.intersect_ray(query)
	if result:
		return result["normal"]
	else:
		return Vector3.UP


func RayDirectionCheck(pos: Vector3, direction: Vector3) -> bool:
	var space_state = get_world_3d().direct_space_state

	var origin = pos
	var end = pos + direction + Vector3(0, 1.1, 0)
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	var result = space_state.intersect_ray(query)
	if result:
		return true
	else:
		return false

func RayGetFloorHeight(pos: Vector3) -> float:
	var space_state = get_world_3d().direct_space_state

	var origin = pos + (Vector3.UP * 1.1)
	var end = pos + Vector3.DOWN * blockSize
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	var result = space_state.intersect_ray(query)
	if result:
		return result["position"].y
	else:
		return -999

func RayDirectionCheckFloor(pos: Vector3, direction: Vector3) -> float:
	var space_state = get_world_3d().direct_space_state

	var origin = pos + direction + Vector3(0, 1.1, 0)
	var end = pos + direction + (Vector3.DOWN * blockSize) + Vector3(0, -0.1, 0)
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	var result = space_state.intersect_ray(query)
	if result:
		return true
	else:
		return false

func SelectRandomTile(awayFrom: MapTile = null, distance: float = 0) -> MapTile:
	if awayFrom == null:
		return Map[randi() % Map.size()]
	else:
		var tile = Map[randi() % Map.size()]
		while tile.position.distance_to(awayFrom.position) < distance && floor(tile.position.y) == floor(awayFrom.position.y):
			print("random invalid")
			tile = Map[randi() % Map.size()]
		return tile

func SpawnNewEnemy():
	var newEnemy: Enemy = enemyList[randi() % enemyList.size()].instantiate()
	add_child(newEnemy)
	newEnemy.currentTile = SelectRandomTile(GameManager.instance.playerRef.currentTile, 5)
	newEnemy.position = newEnemy.currentTile.position

func PathFindTo(from: MapTile, to: MapTile) -> MapTile:
	if from == to:
		return from

	from.path = 0
	var pathToCheck: Array[MapTile] = []
	pathToCheck.append(from)

	var checkedTiles: Array[MapTile] = []

	while pathToCheck.size() > 0:
		var currentTile = pathToCheck[0]
		checkedTiles.append(currentTile)
		pathToCheck.remove_at(0)
		for side in currentTile.sides:
			if side != null && !checkedTiles.has(side) && !pathToCheck.has(side):
				side.path = currentTile.path + 1
				if side == to:
					return PathFirst(to, checkedTiles)
				pathToCheck.append(side)
	return from

func PathFirst(currentTile: MapTile, checkedTiles: Array[MapTile]) -> MapTile:
	while currentTile.path > 1:
		for side in currentTile.sides:
			if side != null:
				if checkedTiles.has(side):
					if currentTile.path > side.path:
						currentTile = side
						if currentTile.path == 1:
							return currentTile
	return currentTile
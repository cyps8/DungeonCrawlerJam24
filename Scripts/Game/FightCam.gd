extends Camera3D

var playerRef: Node3D

var currentLook: Vector3

func _ready():
	playerRef = Fight.instance.get_node("%FightPlayer")
	currentLook = Vector3(0, 0.5, 0)

func _process(_delta):
	currentLook = lerp(currentLook, lerp(playerRef.global_position, Vector3(0, 0.5, 0), 0.5), 0.1)
	look_at(currentLook, Vector3.UP)

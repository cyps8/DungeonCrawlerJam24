extends CharacterBody3D

const moveSpeed = 0.25

var caneraRef: Camera3D

func _ready():
	caneraRef = Fight.instance.get_node("%FightCam")

func _physics_process(_delta):
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# Adjust direction based on rotation of camera
	direction = direction.rotated(Vector3.UP, caneraRef.rotation.y)
	if direction:
		velocity += direction * moveSpeed
	
	# Friction
	velocity = lerp(velocity, Vector3.ZERO, 0.07)

	# Rotate sprite based on velocity smoothly
	if velocity.length() > 0:
		var target_rotation = Vector3(0, atan2(velocity.x, velocity.z) - PI/2, 0)
		$Sprite.rotation.y = lerp_angle($Sprite.rotation.y, target_rotation.y, 0.2)
		$Sprite.scale.x = 1 + (velocity.length() /20)
		$Sprite.scale.z = 1 - (velocity.length() /30)

	move_and_slide()

	if position.distance_to(Vector3(0, 0.25, 0)) > 3.3:
		position = lerp(position, Vector3(0, 0.25, 0), 0.01)

func Burst():
	%Burst.emitting = true
	velocity = Vector3(0, 0, 0)
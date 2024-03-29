extends Node3D

class_name Enemy

var currentTile: MapTile

var moveCD: float = 0.3
var moveTimer: float = 0.0

var moveTween: Tween

func PlayerCollision(_area):
	if _area.get_parent().is_in_group("Player"):
		GameManager.instance.SwitchToFight.call_deferred()
		queue_free()
		pass

func _process(_delta):
	moveTimer -= _delta
	if moveTimer < 0:
		moveTimer += moveCD
		MoveToPlayer()

func MoveToPlayer():
	currentTile = Level.instance.PathFindTo(currentTile, GameManager.instance.playerRef.currentTile)
	if moveTween != null:
		moveTween.kill()
	moveTween = create_tween()
	moveTween.tween_property(self, "position", currentTile.position, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func TeleportAway(_area):
	if _area.is_in_group("Flash"):
		if moveTween != null:
			moveTween.kill()
		currentTile = Level.instance.SelectRandomTile(GameManager.instance.playerRef.currentTile, 5)
		position = currentTile.position
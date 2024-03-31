extends AnimatableBody3D

var opened = false

@export var itemRequired: Item

var gotObjective = false

signal objectiveComplete

@export var locked: bool = false

func Interact(_tile: MapTile):
	if locked:
		AudioPlayer.instance.PlaySound(4, AudioPlayer.SoundType.SFX)
		GameManager.instance.hudRef.ShowHint("Door is locked")
		return

	if opened:
		return

	if itemRequired != null:
		if GameManager.instance.invRef.HasItem(itemRequired):
			GameManager.instance.hudRef.ShowHint(itemRequired.name + " was used to open the door")
		else:
			GameManager.instance.hudRef.ShowHint("You need a " + itemRequired.name + " to open the door")
			AudioPlayer.instance.PlaySound(4, AudioPlayer.SoundType.SFX)
			if !gotObjective:
				gotObjective = true
				GameManager.instance.invRef.AddObjective("Open the door with a " + itemRequired.name, objectiveComplete)
			return

	if gotObjective:
		emit_signal("objectiveComplete")

	opened = true
	
	$Shape.position.y += 2

	AudioPlayer.instance.PlaySound(3, AudioPlayer.SoundType.SFX)

	var openTween = create_tween()
	openTween.tween_property($MeshR, "position:x", $MeshR.position.x + 0.8, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	openTween.set_parallel(true)
	openTween.tween_property($MeshL, "position:x", $MeshL.position.x - 0.8, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)

	Level.instance.ExpandMap(_tile)

extends StaticBody3D

signal objectiveComplete

var interacted = false

func _ready():
	var waitasec: Tween = create_tween()
	waitasec.tween_interval(0.01)
	waitasec.tween_callback(AddObj)

func AddObj():
	GameManager.instance.invRef.AddObjective("Find power switch in the security office.", objectiveComplete)

func Interact(_tile: MapTile):
	if interacted:
		return
	interacted = true
	emit_signal("objectiveComplete")
	GameManager.instance.hudRef.ShowHint("Power switched on")
	GameManager.instance.powerFixed = true

	AudioPlayer.instance.PlaySound(9, AudioPlayer.SoundType.SFX)

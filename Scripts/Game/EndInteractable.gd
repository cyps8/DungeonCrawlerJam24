extends StaticBody3D

signal objectiveComplete

var interacted = false

var canLeave = false

func AddObj():
	GameManager.instance.invRef.AddObjective("Escape.", objectiveComplete)
	canLeave = true

func Interact(_tile: MapTile):
	if !canLeave:
		AudioPlayer.instance.PlaySound(4, AudioPlayer.SoundType.SFX)
		GameManager.instance.hudRef.ShowHint("Can't leave yet...")
		return
	if interacted:
		return
	interacted = true
	emit_signal("objectiveComplete")
	GameManager.instance.hudRef.ShowHint("ESCAPED")
	GameManager.instance.Escaped()
extends Node3D

class_name Enemy

var currentTile: MapTile

func PlayerCollision(_area):
	GameManager.instance.SwitchToFight.call_deferred()
	queue_free()
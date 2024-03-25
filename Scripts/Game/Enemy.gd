extends Node3D

class_name Enemy

var currentTile: MapTile

func PlayerCollision(_area):
	print("Start encounter")
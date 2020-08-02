extends Node2D

export (float) var SPEED = 100

func move(dir, delta):
	position += SPEED * dir * delta

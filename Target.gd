extends CharacterBody3D

@export var speed = 0
@export var max_health = 100
@export var current_health = 100
func initialize(position, direction):
	

func kill():
	current_health = 0
	queue_free()

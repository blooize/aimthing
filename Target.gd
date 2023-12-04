extends CharacterBody3D

@export var speed = 0
@export var max_health = 100
@export var current_health = 0
func initialize(position, direction):
	look_at_from_position(position, direction, Vector3.UP)
	current_health = max_health

func kill():
	current_health = 0
	queue_free()

func _on_timer_timeout():
	kill()

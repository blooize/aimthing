extends Node

@export var target_scene: PackedScene
var captured = false;
var target_queue = []
@onready var locations = [$"World/Spawn Pos", $"World/Spawn Pos2", $"World/Spawn Pos3",
 $"World/Spawn Pos4", $"World/Spawn Pos5", $"World/Spawn Pos6"]
var targets = []
var since_last_spawn = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	since_last_spawn += delta
	if Input.is_action_just_pressed("interact") && !captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		captured = true
		
	if Input.is_action_just_pressed("exit") && captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		captured = false
		
	#if target_queue.size() < 4:
	spawnTarget()
		

func spawnTarget():
	if since_last_spawn >= 1:
		var look_vector = Vector3(0,0,0)
		var target = target_scene.instantiate()
		var index = randi_range(0, locations.size()-1)
		var position = locations[index]
		print_debug(position.global_position)
		for i in targets:
			if i.transform == position.global_position:
				return

		target.initialize(position.global_position, look_vector)
		targets.append(target)
		since_last_spawn = 0

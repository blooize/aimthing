extends Node

@export var target_scene: PackedScene
var captured = false;
var target_queue = []
var locations = []
var targets = []
var since_last_spawn = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var world = find_child("World")
	for c in world.get_children():
		if is_instance_of(c, Marker3D):
			locations.append(c)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	since_last_spawn += delta
	if Input.is_action_just_pressed("interact") && !captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		captured = true
		
	if Input.is_action_just_pressed("exit") && captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		captured = false
		
	if target_queue.size() < 4:
		spawnTarget()

func spawnTarget():
	if since_last_spawn >= 1:
		var look_vector = Vector3(0,0,0)
		var target = target_scene.instantiate()
		var index = randi_range(0, locations.size()-1)
		var position = locations[index]

		target.initialize(position.global_position, look_vector)
		targets.append(target)
		add_child(target)
		since_last_spawn = 0

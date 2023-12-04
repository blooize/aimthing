extends CharacterBody3D

var counter = 0
@export var speed = 1
@export var jump_impulse = 1
@export var gravity = 9.81
@export var mouse_sens = 0.001 #radiants per pixel
@onready var camera = $Pivot/Camera3D.global_transform


var sprinting = false
var jumping = false

func _physics_process(delta):

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_impulse
		
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		if sprinting:
			velocity.x = direction.x * speed * 1.5
			velocity.z = direction.z * speed * 1.5
		else:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		
	
	move_and_slide()
	if Input.is_action_just_pressed("shoot"):
		shoot()
		


func shoot():
	var regex = RegEx.new()
	regex.compile("Target.*")
		
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create($Pivot/Camera3D.global_position,
			$Pivot/Camera3D.global_position - $Pivot/Camera3D.global_transform.basis.z * 100)

	var collision = space.intersect_ray(query)
	
	if collision:
		var result = regex.search(collision.collider.name)
		if result:
			counter += 1
			$Pivot/Camera3D/CanvasLayer/Label.text = str(counter)
			collision.collider.kill()
	

func _process(_delta):
	if Input.is_action_pressed("sprint"):
		sprinting = true
	if Input.is_action_just_released("sprint"):
		sprinting = false
		
func _unhandled_input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED: 
		rotate_y(-event.relative.x * mouse_sens)
		$Pivot.rotate_x(-event.relative.y * mouse_sens)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)

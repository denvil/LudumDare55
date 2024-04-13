extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var visuals = $Visuals
@onready var pickup_circle = $PickupCircle
@onready var carry_slot = $CarrySlot

var push_force = 0.9
var rotation_speed = 10.0
var last_direction = Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


var is_carrying = false
var current_highlight: Node3D

func try_interaction():
	# Check if there is interactable objects. if not then throw the item
	# TODO check
	var body = current_highlight as RigidBody3D
	body.freeze = false
	body.follow_component.target = null
	body.follow_component.is_active = false
	is_carrying = false
	body.apply_central_impulse(last_direction.normalized()*3 + Vector3.UP*3)
	
func try_pickup():
	if not current_highlight:
		return
	# Disable physics on current_highligh
	var body = current_highlight as RigidBody3D
	body.freeze = true
	# Reparent the object
	body.follow_component.target = carry_slot
	body.follow_component.is_active = true
	# Tween it to carry position
	is_carrying = true
	GameEvents.emit_new_highligh(current_highlight)

func handle_action():
	if is_carrying:
		try_interaction()
	else:
		try_pickup()

func _process(delta):
	# Handle pickup
	if Input.is_action_just_pressed("Action"):
		handle_action()
	
	
	if is_carrying:
		return
	var current_distance = 10000000
	if current_highlight:
		current_distance = global_position.distance_squared_to(current_highlight.global_position)
	
	for body: Node3D in pickup_circle.get_overlapping_bodies():
		var distance = global_position.distance_squared_to(body.global_position)
		if distance < current_distance:
			current_highlight = body
			current_distance = global_position.distance_squared_to(current_highlight.global_position)
			GameEvents.emit_new_highligh(current_highlight)
	if len(pickup_circle.get_overlapping_bodies()) == 0:
		current_highlight = null
		GameEvents.emit_new_highligh(current_highlight)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if direction != Vector3.ZERO:
		last_direction = direction
		# Slerp lookat rotation of visuals
		visuals.rotation.y =  lerp_angle(visuals.rotation.y, atan2(direction.x, direction.z), delta*rotation_speed)




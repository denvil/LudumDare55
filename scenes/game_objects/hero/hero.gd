extends RigidBody3D

@export var follow_component: FollowTarget
var id: int
var dummy: bool = false

func _process(delta):
	# Kill zone
	if global_position.y < -10:
		if dummy:
			queue_free()
		else:
			global_position = Vector3(0, 3, 0)

extends RigidBody3D

@export var follow_component: FollowTarget
var id: int

func _process(delta):
	# Kill zone
	if global_position.y < -10:
		global_position = Vector3(0, 3, 0)

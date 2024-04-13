extends RigidBody3D

@export var follow_component: FollowTarget

func _process(delta):
	# Kill zone
	if global_position.y < -10:
		queue_free()

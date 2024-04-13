extends Node3D
# This will slerp parent towards the target
class_name FollowTarget

@export var target: Node3D
var control: Node3D
var acceleration: float = 8
var is_active: bool = false

func _ready():
	control = get_parent_node_3d()

func _process(delta):
	if target == null or not is_active:
		return
	var distance = control.global_position.distance_squared_to(target.global_position)
	control.global_position = control.global_position.slerp(target.global_position,  1 - exp(-acceleration * delta))

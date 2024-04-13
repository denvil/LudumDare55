extends Camera3D
@onready var player = $"../Player"

@export var lerp_speed = 3.0
@export var offset = Vector3.ZERO

func _physics_process(delta):
	if !player:
		return

	var target_xform = player.global_transform.translated_local(offset)
	global_transform = global_transform.interpolate_with(target_xform, lerp_speed * delta)

	look_at(player.global_transform.origin, player.transform.basis.y)
	

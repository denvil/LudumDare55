extends Node3D

func _on_area_3d_body_entered(body):
	body.can_open_shop = true


func _on_area_3d_body_exited(body):
	body.can_open_shop = false


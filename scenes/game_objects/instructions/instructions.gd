extends Node3D


func _on_area_3d_body_entered(body):
	body.instructions = self


func _on_area_3d_body_exited(body):
	body.instructions = self

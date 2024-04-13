extends Node

signal current_highligh_changed(body: Node3D)

func emit_new_highligh(body: Node3D):
	current_highligh_changed.emit(body)

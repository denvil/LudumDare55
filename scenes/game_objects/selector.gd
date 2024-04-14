extends Node3D

@onready var root_scene = %"Root Scene"
var is_visible: bool = false
func _ready():
	root_scene.hide()
	GameEvents.current_highligh_changed.connect(_focus_changed)
	
func _focus_changed(body: Node3D):
	if not body:
		is_visible = false
		root_scene.hide()
		return
	global_position = body.global_position
	is_visible = true
	root_scene.show()

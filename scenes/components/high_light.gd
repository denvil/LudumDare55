extends Node3D
@onready var mesh = $Mesh

func _ready():
	GameEvents.current_highligh_changed.connect(on_current_highlight_changed)
	mesh.hide()
	
func on_current_highlight_changed(body: Node3D):
	if body == get_parent_node_3d():
		mesh.show()
	else:
		mesh.hide()

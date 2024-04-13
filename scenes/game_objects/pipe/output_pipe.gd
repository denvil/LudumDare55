extends Node3D
class_name OutputPipe
@onready var indicator = $Indicator

func _ready():
	indicator.hide()

func _on_dropoff_area_body_entered(body):
	if body.is_carrying:
		indicator.show()
		body.dropoff_pipe = self


func _on_dropoff_area_body_exited(body):
	indicator.hide()
	body.dropoff_pipe = null

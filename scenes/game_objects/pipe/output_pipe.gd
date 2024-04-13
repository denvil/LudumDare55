extends Node3D
class_name OutputPipe
@onready var indicator = $Indicator
@export var slot: int
@onready var game_manager = $"../../GameManager"

func _ready():
	indicator.hide()

func _on_dropoff_area_body_entered(body):
	print("Area entered " + str(slot))
	print(game_manager.active_events[slot])
	if game_manager.active_events[slot] == null:
		return
	if body.is_carrying:
		indicator.show()
		body.dropoff_pipe = self


func _on_dropoff_area_body_exited(body):
	indicator.hide()
	body.dropoff_pipe = null

extends CanvasLayer

func _ready():
	get_tree().paused = true
	%Continue.grab_focus()


func _on_continue_pressed():
	get_tree().paused = false
	queue_free()


func _on_options_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

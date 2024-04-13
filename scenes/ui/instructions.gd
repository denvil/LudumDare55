extends CanvasLayer

func _ready():
	get_tree().paused = true
	%ContinueButton.grab_focus()

func _on_button_pressed():
	get_tree().paused = false
	GameEvents.emit_instructions_done()
	queue_free()

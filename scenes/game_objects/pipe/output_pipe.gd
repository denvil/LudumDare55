extends Node3D
class_name OutputPipe
@onready var indicator = $Indicator
@onready var animation_player = $AnimationPlayer
@export var hero_scene: PackedScene
@export var slot: int = 0
@export var slot_name: String = "I"
@export var game_manager: GameManager = null
var is_open = false

func _ready():
	%Label.text = slot_name

func _on_dropoff_area_body_entered(body):
	if game_manager.active_events[slot] == null:
		return
	if body.is_carrying:
		if animation_player.current_animation != "":
			await animation_player.animation_finished
		animation_player.play("Open")
		body.dropoff_pipe = self
		is_open = true


func _on_dropoff_area_body_exited(body):
	if is_open:
		if animation_player.current_animation != "":
			await animation_player.animation_finished
		animation_player.play_backwards("Open")
		body.dropoff_pipe = null
		is_open = false

func play_send_animation():
	var hero_dummy = hero_scene.instantiate()
	hero_dummy.dummy = true
	%HeroBulletPivot.add_child(hero_dummy)
	if animation_player.current_animation != "":
		await animation_player.animation_finished
	animation_player.play("Launch")
	

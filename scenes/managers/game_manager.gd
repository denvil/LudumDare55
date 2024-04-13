extends Node

@export var event_db: Array[Event]
var pause_screen_scene = preload("res://scenes/ui/pause_menu.tscn")
signal game_over
@onready var summon_timer = $SummonTimer
var hero_scene = preload("res://scenes/game_objects/hero/hero.tscn")
@onready var input = $"../Input"

var hero_queue

func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		add_child(pause_screen_scene.instantiate())
		get_tree().root.set_input_as_handled()

func _ready():
	pass


func _on_summon_timer_timeout():
	# Start next timer
	summon_timer.start()
	
	# See if we can summon next hero
	var hero = hero_scene.instantiate()
	hero.global_position = input.global_position
	var items_layer = get_tree().get_first_node_in_group("SceneItems")
	items_layer.add_child(hero)
	hero.apply_central_impulse(Vector3.RIGHT*3 + Vector3.UP*3)
	
	

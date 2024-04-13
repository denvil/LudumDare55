extends Node

@export var base_decay_rate: float = 0.015
@export var base_progress_rate: float = 0.02

@export var event_db: EventPool
@export var hero_pool: HeroPool
var pause_screen_scene = preload("res://scenes/ui/pause_menu.tscn")
var shop_screen_scene = preload("res://scenes/ui/portal_shop.tscn")
signal game_over
@onready var summon_timer = $SummonTimer
var hero_scene = preload("res://scenes/game_objects/hero/hero.tscn")
@onready var input = $"../Input"
var id_counter = 0
var active_heroes: Array[Hero]
var active_events: Array = [null, null, null]
var available_heroes: Array[HeroResource]
@export var starter_hero: HeroResource
@onready var gold = %Gold
var current_gold:int = 0

var current_difficulty_cutoff: float = 0.3

# Keep track of how many completed quests
var current_completed_quests: int = 0

func update_gold():
	%Gold.text = "Gold: "+str(current_gold)+"g"
	GameEvents.emit_update_gold(current_gold)

func get_hero(id: int):
	for hero in active_heroes:
		if hero.id == id:
			return hero

func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		add_child(pause_screen_scene.instantiate())
		get_tree().root.set_input_as_handled()


func get_first_slot():
	for i in range(3):
		if active_events[i] == null:
			return i
	return -1

func add_quest(event: Event):
	# Check if there is free quest slots
	var empty_slot = get_first_slot()
	if empty_slot == -1:
		return
	GameEvents.add_quest_event(event, empty_slot)
	active_events[empty_slot] = {
		"event": event,
		"progress": 0.0,
		"current_hero": null,
		"slot": empty_slot
	}

func get_easy_mission():
	var event = event_db.events.filter(func(event:Event): return event.difficulty <= 0.3).pick_random()
	add_quest(event)

func update_quests():
	if current_completed_quests == 0:
		get_easy_mission()
		return
	# Try to fill all slots
	for x in range(3):
		var event = event_db.events.filter(func(event:Event): return event.difficulty <= current_difficulty_cutoff).pick_random()
		add_quest(event)
	# Update heroes
	while len(available_heroes) < 3:
		var new_hero = hero_pool.heropool.pick_random()
		if new_hero not in available_heroes:
			available_heroes.append(new_hero)


func remove_event(event):
	active_events[event["slot"]] = null
	GameEvents.update_quest(event["slot"], null)

func _ready():
	GameEvents.open_shop.connect(_open_shop)
	GameEvents.buy_hero.connect(_buy_hero)
	GameEvents.instructions_done.connect(_instructions_done)
	GameEvents.sending_hero.connect(_sending_hero)

	
func _sending_hero(slot: int, hero: int):
	active_events[slot]["current_hero"] = hero
	print(slot)
	print(active_events[slot])

func _instructions_done():
	# Instructions are done. Generate first event
	update_quests()
	$LevelTimer.start()
	# Add starter hero
	available_heroes.append(starter_hero)

func _open_shop():
	var shop = shop_screen_scene.instantiate()
	add_child(shop)
	shop.setup(available_heroes, current_gold)
	
func _buy_hero(hero: HeroResource):
	# See if we can summon next hero
	var hero_data = Hero.new()
	hero_data.id = id_counter
	hero_data.charisma = hero.charisma
	hero_data.strength = hero.strength
	hero_data.wisdom = hero.wisdom
	hero_data.name = hero.name
	id_counter += 1
	
	current_gold -= hero.price
	update_gold()
	
	active_heroes.append(hero_data)
	available_heroes.remove_at(available_heroes.find(hero))
	
	return_hero(hero_data)

func calculate_hero_progression(hero: Hero, event: Event):
	# How relevant the hero is
	# Quest event weights
	var total:float = event.strength + event.wisdom + event.charisma
	var w_str:float = event.strength / total
	var w_wis:float = event.wisdom / total
	var w_cha:float = event.charisma / total
	var hero_stat_relevance = (w_str * hero.strength + w_wis * hero.wisdom + w_cha * hero.charisma) / (w_str+w_wis+w_cha)
	var base_progress = (hero_stat_relevance / event.difficulty) * base_progress_rate
	# Random 
	return base_progress + randf_range(-0.001, 0.001)

func return_hero(hero):
	var hero_inst = hero_scene.instantiate()
	var items_layer = get_tree().get_first_node_in_group("SceneItems")
	items_layer.add_child(hero_inst)
	hero_inst.id = hero.id
	hero_inst.global_position = input.global_position
	hero_inst.apply_central_impulse(Vector3.RIGHT*3 + Vector3.UP*3)

func event_succeed(event):
	print("Event succeed", event)
	if event["current_hero"] != null:
		var hero = get_hero(event["current_hero"])
		return_hero(hero)
	# Remove event
	remove_event(event)
	current_completed_quests += 1
	current_gold += (event["event"] as Event).reward
	update_gold()
	update_quests()
	
func event_failed(event):
	print("Event failed", event)

func progress_event(event):
	if event == null:
		return
	var event_data = event["event"] as Event
	if event["current_hero"] == null:
		# This is bad! Depending on difficulty minus progression
		event["progress"] -= event_data.difficulty * base_decay_rate
	else:
		var hero = get_hero(event["current_hero"])
		# Check if this hero is good enough
		event["progress"] += calculate_hero_progression(hero, event_data)
	if event["progress"] >= 1:
		event_succeed(event)
		return
	elif event["progress"] <= -1:
		event_failed(event)
		return
	GameEvents.update_quest(event["slot"], event)

func _on_level_timer_timeout():
	# This will tick Quest along
	for event in active_events:
		progress_event(event)
		

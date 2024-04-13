extends CanvasLayer
var hero_container = preload("res://scenes/ui/shop_hero_container.tscn")
@onready var available_heroes = %AvailableHeroes

func setup(heroes: Array[HeroResource], gold: int):
	for hero in heroes:
		if hero == null:
			continue
		var inst = hero_container.instantiate()
		available_heroes.add_child(inst)
		# hero.set_hero()
		inst.buy_button_pressed.connect(on_buy_hero.bind(inst, hero))
		inst.setup(hero, gold)

	if len(heroes) == 0:
		%CloseButton.grab_focus()

func _on_close_button_pressed():
	GameEvents.emit_close_shop()
	queue_free()

func on_buy_hero(inst, hero: HeroResource):
	# Animate!i3
	inst.queue_free()
	GameEvents.emit_buy(hero)
	# Change focus to next hero if there is. if no heroes then
	# foxu on continue button
	%CloseButton.grab_focus()

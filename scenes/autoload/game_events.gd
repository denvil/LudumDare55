extends Node

signal current_highligh_changed(body: Node3D)
signal open_shop
signal close_shop
signal buy_hero(hero: HeroResource)
signal instructions_done
signal new_quest_event(event: Event, slot: int)
signal on_update_quest(slot: int, event)
signal sending_hero(slot: int, hero: int)
signal update_gold(gold: int)

func emit_new_highligh(body: Node3D):
	current_highligh_changed.emit(body)

func emit_open_shop():
	open_shop.emit()

func emit_close_shop():
	close_shop.emit()

func emit_buy(hero: HeroResource):
	buy_hero.emit(hero)
	
func emit_instructions_done():
	instructions_done.emit()
	
func add_quest_event(event: Event, slot: int):
	new_quest_event.emit(event, slot)

func send_hero(slot: int, hero: int):
	sending_hero.emit(slot, hero)

func update_quest(slot: int, event):
	on_update_quest.emit(slot, event)

func emit_update_gold(gold: int):
	update_gold.emit(gold)

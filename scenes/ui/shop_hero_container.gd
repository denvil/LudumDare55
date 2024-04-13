extends PanelContainer
@onready var buy_button = %BuyButton
signal buy_button_pressed
var price: int = 0
func _ready():
	buy_button.pressed.connect(buy)
	GameEvents.update_gold.connect(update_gold)

func update_gold(gold):
	if price == 0:
		%BuyButton.text = "FREE"
	else:
		%BuyButton.text = str(price) + "g"
		if gold < price:
			%BuyButton.disabled = true

func setup(hero: HeroResource, gold: int):
	buy_button.grab_focus()
	price = hero.price
	update_gold(gold)
	%Name.text = hero.name
	%Strength.text = str(hero.strength)
	%Wisdom.text = str(hero.wisdom)
	%Charisma.text = str(hero.charisma)

func disable():
	queue_free()

func buy():
	buy_button_pressed.emit()

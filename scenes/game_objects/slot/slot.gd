extends Node3D

@onready var details = %Details
@export var slot_id: int
@export var slot_name: String

var flavour_text: Array[String] = [
	"Sharpening a broadsword, ready for the next big challenge.",
	"Mixing herbs and potions to heal unknown ailments.",
	"Disappearing into the shadows, silently observing the enemy.",
	"Testing the weight of a newly forged shield, feeling its balance.",
	"Reciting incantations that light up the ancient runes around.",
	"Scouting ahead, mapping unknown territories for allies.",
	"Flipping a coin that seems enchanted, always landing on heads.",
	"Studying the stars, searching for signs of coming events.",
	"Forging a mighty axe, its blade gleaming under the forge’s fire.",
	"Picking a lock with expert precision, barely making a sound.",
	"Conjuring small flames, practicing precise control over fire.",
	"Mediating an argument with a calm and steady voice.",
	"Gathering intelligence from tavern tales and drunken whispers.",
	"Researching ancient scrolls, dust swirling in the dim light.",
	"Sharpening the edge of a dagger, preparing for silent threats.",
	"Calling upon the wind, feeling its power surge through.",
	"Leading a war chant that boosts the morale of many.",
	"Manipulating the very earth, creating barriers and pathways.",
	"Tinkering with a mysterious device that ticks endlessly.",
	"Tracking elusive wildlife across rugged terrains, unnoticed.",
	"Mending torn battle flags, stitching history back together.",
	"Blending into the festival crowd, eyes alert for any threat.",
	"Drawing arcane symbols in the air, channeling hidden energies.",
	"Tending to a wounded animal, whispering words of comfort.",
	"Loading a crossbow, the air tense with anticipation.",
	"Examining mysterious footprints, deducing their origins.",
	"Singing a haunting melody that echoes through the valley.",
	"Deciphering a cryptic message left by an ancient civilization.",
	"Preparing herbal remedies from freshly gathered plants.",
	"Animating shadows to dance and creep along the walls.",
	"Studying a complex map, plotting a course through dangerous waters.",
	"Carving runes into a wooden staff, each symbol pulsing with power.",
	"Practicing swordplay at dawn, movements sharp and precise.",
	"Brewing a storm in a teacup, literally.",
	"Testing potions with a cautious sip, noting the effects.",
	"Laying traps along a forest path, securing the area.",
	"Consulting star charts, aligning plans with celestial movements.",
	"Balancing atop a precarious ledge, scouting from above.",
	"Weaving a protective spell over a sleeping village.",
	"Reading the wind, predicting changes in the weather.",

]

var interval = 0

func _ready():
	details.hide()
	GameEvents.new_quest_event.connect(_update_slot)
	GameEvents.on_update_quest.connect(_on_update_quest)
	%SlotNumber.text = slot_name


func update_difficulty(event: Event):
	if event.difficulty <= 0.3:
		%Difficulty.text = "Easy"
		%Difficulty.modulate = Color.GREEN
		return
	if event.difficulty <= 0.6:
		%Difficulty.text = "Moderate"
		%Difficulty.modulate = Color.BLUE
		return
	if event.difficulty <= 0.8:
		%Difficulty.text = "Challenging"
		%Difficulty.modulate = Color.ORANGE
		return
	
	%Difficulty.text = "Hard"
	%Difficulty.modulate = Color.RED

	
func _update_slot(event: Event, slot: int):
	
	if slot != slot_id:
		# Not mine... abort
		return
	if event == null:
		details.hide()
		return
	
	details.show()
	%Title.text = event.name
	%Description.text = event.description
	%Reward.text = str(event.reward)
	update_difficulty(event)
	(%ProgressGood as Node3D).scale.x = 0
	(%ProgressBad as Node3D).scale.x = 0
	%"Progress text".text=""
	%Progress.text = "0%"

func _on_update_quest(slot: int, event):
	if slot != slot_id:
		# Not mine... abort
		return
	if event == null:
		details.hide()
		return
	%Progress.text = str(roundi(event["progress"]*100))+"%"
	(%ProgressGood as Node3D).scale.x = max(0, event["progress"])
	(%ProgressBad as Node3D).scale.x = min(event["progress"], 0)
	if event["current_hero"] != null:
		if interval % 5 == 0:
			%"Progress text".text=flavour_text.pick_random()
		interval += 1
	else:
		%"Progress text".text=""

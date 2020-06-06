extends CanvasLayer

onready var panel = $DialogPanel

var action_dialog_chance = 0.3
var action_reactions = [
	"That feels dangerous",
	"Woah, I can't see my hands",
	"Never again I'm eating these mushrooms",
	"Dude, I think I'm gonna puke"
]

var death_dialog_chance = 0.5
var death_reactions = [
	"I trusted you, dude",
	"Hey, stop it",
	"Nooo"
]

var old_hunger_value = 100.0
const hunger_border = 10.0
var hunger_dialog_chance = 1
var hunger_reactions = [
	"I feel soo hungry",
	"Dude, find me some snaks",
	"I'm gonna starve to death"
]

var bored_dialog_chance = 1
var bored_reactions = [
	"No, don't tell me you're already passed out",
	"Where are you?",
	"Yes, what were we talking about?"
]

var current_tutorial_dialogue = 0
var tutorial_shown = false
var tutorial_dialogues = [
	"Duuude, I think I've stuck in VR",
	"I mean.. I can't take off the helmet. It's stuck on me!",
	"I need to get to the IT support floor..",
	".. but I can't see a thing in this helmet",
	"Can you guide me?"
]


var tutorial_timer: Timer


func _ready():
	_set_active(false)
	Events.connect("player_action_choosen", self, "_on_action_choosen")
	Events.connect("player_hunger_changed", self, "_on_hunger_changed")
	Events.connect("player_inactive_long_time", self, "_on_bored")
	Events.connect("player_died", self, "_on_die")
	Events.connect("start_game", self, "_on_start_game")
	
	tutorial_timer = Timer.new()
	tutorial_timer.connect("timeout", self, "_next_tutorial_dialogue")
	add_child(tutorial_timer)


func _set_active(value):
	panel.visible = value


func _get_active():
	return panel.visible


func _get_text_label():
	if panel != null:
		return panel.get_child(0)
	else:
		return null


func show_dialog(text, wait_time : float):
	_set_active(true)
	var label : Label = _get_text_label()
	label.text = text
	$Timer.wait_time = wait_time
	$Timer.start()


func hide_dialog():
	_set_active(false)


func _on_Timer_timeout():
	hide_dialog()


func _on_action_choosen(action, steps):
	if steps > 1:
		if randf() <= action_dialog_chance:
			show_dialog(action_reactions[randi() % action_reactions.size()], 4)


func _on_hunger_changed(value):
	if old_hunger_value > hunger_border and value <= hunger_border:
		if randf() <= hunger_dialog_chance:
			show_dialog(hunger_reactions[randi() % hunger_reactions.size()], 4)
	old_hunger_value = value


func _on_bored():
	if randf() <= bored_dialog_chance:
		show_dialog(bored_reactions[randi() % bored_reactions.size()], 4)


func _on_die():
	if old_hunger_value > 10:
		if randf() <= death_dialog_chance:
			show_dialog(death_reactions[randi() % death_reactions.size()], 4)


func _on_start_game():
	hide_dialog()
	show_tutorial_dialogues()


func show_tutorial_dialogues():
	if tutorial_shown:
		return
	
	current_tutorial_dialogue = 0
	_next_tutorial_dialogue()
	tutorial_timer.start(4.0)
	tutorial_shown = true


func _next_tutorial_dialogue():
	if current_tutorial_dialogue < tutorial_dialogues.size():
		show_dialog(tutorial_dialogues[current_tutorial_dialogue], 4)
		current_tutorial_dialogue += 1
	else:
		tutorial_timer.stop()

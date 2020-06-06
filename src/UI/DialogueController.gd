extends CanvasLayer

onready var panel = $DialogPanel

var action_dialog_chance = 0.3
var action_reactions = [
	"That feels dangerous",
	"Woah, I can't see my hands",
	"Never again I'm eating these mushrooms",
	"Dude, I think I'm gonna puke"
]

var fall_dialog_chance = 1
var fall_reactions = [
	"I'm flying! I'm flying!",
	"I need a jumpsuit"
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


func _ready():
	_set_active(false)
	Events.connect("player_action_choosen", self, "_on_action_choosen")
	Events.connect("player_hunger_changed", self, "_on_hunger_changed")
	Events.connect("player_inactive_long_time", self, "_on_bored")
	Events.connect("player_falling", self, "_on_falling")


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


func _on_falling():
	if randf() <= fall_dialog_chance:
		show_dialog(fall_reactions[randi() % fall_reactions.size()], 4)

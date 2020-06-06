extends Node

var itemsCount = 0
var itemsCollected = 0

export(Array, PackedScene) var scenes
export(PackedScene) var gameOverOverlay

var current_level_index = 0
var current_level: GameLevel
var collected_percent setget ,get_collected_percent

var input_active = true

func load_level(index):
	current_level_index = index
	get_tree().change_scene_to(scenes[index])
	GameFlow.unlock_character_input()
	
func load_next_level():
	if current_level_index + 1 < scenes.size():
		load_level(current_level_index + 1)

func reload_level():
	load_level(current_level_index)

func _ready():
	Events.connect("item_collected", self, "_on_item_collected")
	Events.connect("level_completed", self, "_on_level_completed")
	Events.connect("level_started", self, "_on_level_started")
	Events.connect("player_died", self, "on_player_death")
	pass 

func _on_item_collected():
	itemsCollected += 1
	print_debug("Collected an item, total: " + str(itemsCollected))
	pass

func _on_level_started():
	var items = get_tree().get_nodes_in_group("Collectables")
	itemsCount = items.size()
	print_debug("Total items: " + str(itemsCount))
	Events.emit_signal("player_hunger_changed", 100)
	pass
	

func _on_level_completed():
	load_next_level()

func get_collected_percent():
	if itemsCount > 0:
		return (itemsCollected / itemsCount) * 100.0
	else:
		return 0
	pass
	
func lock_character_input():
	input_active = false
	pass

func unlock_character_input():
	input_active = true
	pass
	
func on_player_death():
	lock_character_input()
	var overlay = gameOverOverlay.instance()
	add_child(overlay)
	pass


func exit_game():
	get_tree().quit()

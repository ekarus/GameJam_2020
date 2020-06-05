extends Node

var itemsCount = 0
var itemsCollected = 0

export(Array, PackedScene) var scenes

var current_level_index = 0
var current_level: GameLevel
var collected_percent setget ,get_collected_percent

func load_level(index):
	current_level_index = index
	get_tree().change_scene_to(scenes[index])
	Events.emit_signal("level_started")
	
	
func load_next_level():
	if current_level_index < scenes.size():
		load_level(current_level_index + 1)


func _ready():
	Events.connect("item_collected", self, "_on_item_collected")
	Events.connect("level_completed", self, "_on_level_completed")
	Events.connect("level_started", self, "_on_level_started")
	pass 

func _on_item_collected():
	itemsCollected += 1
	print_debug("Collected an item, total: " + str(itemsCollected))
	pass

func _on_level_started():
	var items = get_tree().get_nodes_in_group("Collectables")
	itemsCount = items.size()
	print_debug("Total items: " + str(itemsCount))
	pass
	

func _on_level_completed():
	load_next_level()

func get_collected_percent():
	if itemsCount > 0:
		return (itemsCollected / itemsCount) * 100.0
	else:
		return 0
	pass
	

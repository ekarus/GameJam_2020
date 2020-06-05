extends Node

var itemsCount = 0
var itemsCollected = 0

export(Array, PackedScene) var scenes

var current_level_index = 0
var current_level: GameLevel


func load_level(index):
	current_level_index = index
	get_tree().change_scene_to(scenes[index])
	
	
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
	pass
	

func _on_level_completed():
	load_next_level()

extends Node

var itemsCount = 0
var itemsCollected = 0

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
	pass

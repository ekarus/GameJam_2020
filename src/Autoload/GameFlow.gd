extends Node

var itemsCount = 0
var itemsCollected = 0

export(Array, PackedScene) var scenes
export(PackedScene) var gameOverOverlay
export(PackedScene) var level_complete_overlay = preload("res://src/UI/PopUps/NextLvl_PopUp.tscn")
export(PackedScene) var pause_overlay = preload("res://src/UI/PopUps/Pause_PopUp.tscn")

var pause_overlay_instance

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
	print("next level")


func reload_level():
	load_level(current_level_index)


func _ready():
	Events.connect("item_collected", self, "_on_item_collected")
	Events.connect("level_completed", self, "_on_level_completed")
	Events.connect("level_started", self, "_on_level_started")
	Events.connect("player_died", self, "on_player_death")


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if input_active:
			pause_game()
		else:
			if pause_overlay_instance != null:
				unpause_game()


func _on_item_collected():
	itemsCollected += 1
	print_debug("Collected an item, total: " + str(itemsCollected))


func _on_level_started():
	unlock_character_input()
	show_hud()
	var items = get_tree().get_nodes_in_group("Collectables")
	itemsCount = items.size()
	print_debug("Total items: " + str(itemsCount))
	Events.emit_signal("player_hunger_changed", 100)
	

func _on_level_completed():
	hide_hud()
	lock_character_input()
	var overlay = level_complete_overlay.instance()
	add_child(overlay)


func get_collected_percent():
	if itemsCount > 0:
		return (itemsCollected / itemsCount) * 100.0
	else:
		return 0


func lock_character_input():
	input_active = false


func unlock_character_input():
	input_active = true


func hide_hud():
	current_level._game_hud.hide()


func show_hud():
	if current_level._game_hud != null:
		current_level._game_hud.show()
	pass


func on_player_death():
	hide_hud()
	lock_character_input()
	var overlay = gameOverOverlay.instance()
	add_child(overlay)


func exit_game():
	get_tree().quit()


func pause_game():
	lock_character_input()
	hide_hud()
	pause_overlay_instance = pause_overlay.instance()
	add_child(pause_overlay_instance)
	get_tree().paused = true


func unpause_game():
	unlock_character_input()
	show_hud()
	if pause_overlay_instance:
		pause_overlay_instance.queue_free()
		pause_overlay_instance = null
	get_tree().paused = false


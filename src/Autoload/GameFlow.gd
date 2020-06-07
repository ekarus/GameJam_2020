extends Node

var itemsCount = 0
var itemsCollected = 0

export(Array, PackedScene) var Scenes
export(PackedScene) var gameOverOverlay
export(PackedScene) var level_complete_overlay = preload("res://src/UI/PopUps/NextLvl_PopUp.tscn")
export(PackedScene) var pause_overlay = preload("res://src/UI/PopUps/Pause_PopUp.tscn")
export(PackedScene) var main_menu_overlay = preload("res://src/UI/MainMenu/MainMenu_UI.tscn")
export(PackedScene) var game_won_overlay = preload("res://src/UI/PopUps/WIN_PopUp.tscn")
export(PackedScene) var enemy_explosion = preload("res://src/Actors/Enemies/EnemyDeathSprite.tscn")

export(AudioEffect) var pauseScreenSoundFilter

export var DEBUG_INPUT = false
export var DEBUG_NAVIGATION = false

var pause_overlay_instance
var main_menu_instance

var current_level_index = 0
var current_level: GameLevel
var collected_percent setget ,get_collected_percent

var input_active = true

func load_level(index):
	current_level_index = index
	get_tree().change_scene_to(Scenes[index])
	GameFlow.unlock_character_input()
	
	unlock_character_input()
	show_hud()
	resume_game_time()


func load_next_level():
	if current_level_index + 1 < Scenes.size():
		load_level(current_level_index + 1)
		Events.emit_signal("start_game")
	print("next level")


func load_first_level():
	current_level_index = 0
	load_level(current_level_index)


func reload_level():
	load_level(current_level_index)
	Events.emit_signal("start_game")


func start_new_game():
	load_level(0)
	main_menu_instance = main_menu_overlay.instance()
	$Menu.add_child(main_menu_instance)
	main_menu_instance.show()


func _ready():
	Events.connect("item_collected", self, "_on_item_collected")
	Events.connect("level_completed", self, "_on_level_completed")
	Events.connect("level_started", self, "_on_level_started")
	Events.connect("player_died", self, "on_player_death")
	Events.connect("start_game", self, "on_game_started")
	Events.connect("enemy_death", self, "_on_enemy_death")


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if input_active:
			pause_game()
		else:
			if pause_overlay_instance != null:
				unpause_game()


func on_game_started():
	if main_menu_instance:
		main_menu_instance.hide()
	

func _on_item_collected():
	itemsCollected += 1
	print("Collected an item, total: " + str(itemsCollected))


func _on_level_started():
	var items = get_tree().get_nodes_in_group("Collectables")
	itemsCount = items.size()
	print("Total items: " + str(itemsCount))
	$bgm_game.play()
	Events.emit_signal("player_hunger_changed", 100)


func _on_level_completed():
	hide_hud()
	lock_character_input()
	pause_game_time()
	$bgm_game.stop()
	$win_jingle.play()
	if current_level_index + 1 < Scenes.size():
		var overlay = level_complete_overlay.instance()
		add_child(overlay)
	else:
		var overlay = game_won_overlay.instance()
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
	if current_level and current_level._game_hud != null:
		current_level._game_hud.show()


func on_player_death():
	pause_game_time()
	hide_hud()
	lock_character_input()
	$bgm_game.stop()
	$lose_jinge.play()
	var overlay = gameOverOverlay.instance()
	add_child(overlay)


func exit_game():
	get_tree().quit()


func pause_game():
	lock_character_input()
	hide_hud()
	AudioServer.add_bus_effect(0, pauseScreenSoundFilter, 0)
	pause_overlay_instance = pause_overlay.instance()
	add_child(pause_overlay_instance)
	pause_game_time()


func unpause_game():
	unlock_character_input()
	show_hud()
	if pause_overlay_instance:
		pause_overlay_instance.queue_free()
		pause_overlay_instance = null
	AudioServer.remove_bus_effect(0, 0)
	resume_game_time()


func pause_game_time():
	get_tree().paused = true

func resume_game_time():
	get_tree().paused = false

func _on_enemy_death(position):
	var sprite : AnimatedSprite = enemy_explosion.instance()
	sprite.global_position = position
	add_child(sprite)
	$enemy_death_sound.global_position = position
	$enemy_death_sound.play()


func is_main_menu_open():
	return main_menu_instance != null && main_menu_instance.visible

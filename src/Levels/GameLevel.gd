extends Node2D

class_name GameLevel

export var LIMIT_LEFT = -10000
export var LIMIT_TOP = -10000
export var LIMIT_RIGHT = 10000
export var LIMIT_BOTTOM = 10000

var player: Player

export var actions_speed_multiplier = 1.0
export var actions_dencity_multiplier = 1.0
export var player_hunger_speed = 0.01

export(PackedScene) var GameHudScene = preload("res://src/UI/IngameHUD.tscn")

var _game_hud = null

func _ready():
	player = $Player
	GameFlow.current_level = self
	Events.emit_signal("level_started")
	print("Started level - %s" % name)
	
	for child in get_children():
		if child is Player:
			var camera = child.get_node("Camera2D")
			camera.limit_left = LIMIT_LEFT
			camera.limit_top = LIMIT_TOP
			camera.limit_right = LIMIT_RIGHT
			camera.limit_bottom = LIMIT_BOTTOM
	
	player.hunger_speed = player_hunger_speed
	
	_game_hud = GameHudScene.instance()
	add_child(_game_hud)

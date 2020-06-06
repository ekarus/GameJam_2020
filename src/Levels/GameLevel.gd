extends Node2D

class_name GameLevel

export var LIMIT_LEFT = -10000
export var LIMIT_TOP = -10000
export var LIMIT_RIGHT = 10000
export var LIMIT_BOTTOM = 10000

var player: Player

export(PackedScene) var game_hud = preload("res://src/UI/IngameHUD.tscn")

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
	
	add_child(game_hud.instance())

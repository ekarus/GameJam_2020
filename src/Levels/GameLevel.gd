extends Node2D

class_name GameLevel


var player: Player

func _ready():
	player = $Player
	GameFlow.current_level = self
	Events.emit_signal("level_started")
	print("Started level - %s" % name)

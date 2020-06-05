extends Node2D

export var LIMIT_LEFT = -315
export var LIMIT_TOP = -250
export var LIMIT_RIGHT = 955
export var LIMIT_BOTTOM = 690

func _ready():
	for child in get_children():
		if child is Player:
			var camera = child.get_node("Camera2D")
			camera.limit_left = LIMIT_LEFT
			camera.limit_top = LIMIT_TOP
			camera.limit_right = LIMIT_RIGHT
			camera.limit_bottom = LIMIT_BOTTOM

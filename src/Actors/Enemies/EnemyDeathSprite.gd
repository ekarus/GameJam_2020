extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("animation_finished", self, "_on_anim_finished")
	pass # Replace with function body.

func _on_anim_finished():
	queue_free()

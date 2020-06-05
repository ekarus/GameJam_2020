extends Area2D

func _ready():
	connect("body_entered", self, "_on_ExitPoint_body_entered")


func _on_ExitPoint_body_entered(body):
	if body as Player:
		Events.emit_signal("level_completed")

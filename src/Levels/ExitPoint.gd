extends AnimatedSprite


func _on_Area2D_body_entered(body):
	if body as Player:
		Events.emit_signal("level_completed")

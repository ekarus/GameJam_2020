extends Area2D

export var RestorationValue = 20.0

func _on_body_entered(body):
	if body is Player:
		(body as Player).reduce_hunger(RestorationValue / 100)
		Events.emit_signal("item_collected")
		queue_free()
	pass 

extends Area2D

func _on_body_entered(body):
	if body is Player:
		Events.emit_signal("item_collected")
		var effect : ItemEffectBase = get_node("Effect")
		effect.apply_effect()
		queue_free()
	pass 

extends Area2D

export var RestorationValue = 20.0

func _ready():
	$Pickup_sound.connect("finished", self, "_on_sound_finished")

func _on_body_entered(body):
	if body is Player:
		(body as Player).reduce_hunger(RestorationValue / 100)
		Events.emit_signal("item_collected")
		$AnimatedSprite.play("pick_up")
		$Pickup_sound.play()
	pass 

func _on_sound_finished():
	queue_free()

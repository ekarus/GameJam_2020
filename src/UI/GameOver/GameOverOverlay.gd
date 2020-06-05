extends CanvasLayer

func _process(delta):
	if Input.is_action_pressed("select_action"):
		GameFlow.reload_level()
		queue_free()
	pass

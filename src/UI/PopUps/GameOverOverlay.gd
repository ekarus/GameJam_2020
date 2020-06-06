extends CanvasLayer


func _ready():
	print("game over popup")
	$Loose_PopUp/PopUp/Buttons/StartButton.connect("pressed", self, "_on_restart")
	$Loose_PopUp/PopUp/Buttons/StartButton3.connect("pressed", self, "_on_exit")
	$Loose_PopUp/PopUp/Buttons/StartButton.grab_focus()
	$Loose_PopUp.modulate = Color(255, 255, 255, 0)
	$AnimationPlayer.play("Panel_open")

func _on_restart():
	queue_free()
	GameFlow.reload_level()
	GameFlow.unlock_character_input()


func _on_exit():
	GameFlow.exit_game()

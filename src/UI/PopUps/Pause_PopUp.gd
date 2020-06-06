extends CanvasLayer


func _ready():
	$Pause_PopUp/PopUp/Buttons/StartButton.connect("pressed", self, "_on_continue")
	$Pause_PopUp/PopUp/Buttons/StartButton3.connect("pressed", self, "_on_exit")
	$Pause_PopUp/PopUp/Buttons/StartButton.grab_focus()


func _on_continue():
	GameFlow.unpause_game()


func _on_exit():
	GameFlow.exit_game()

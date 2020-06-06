extends CanvasLayer


func _ready():
	$Win_PopUp/PopUP/Buttons/StartButton2.connect("pressed", self, "_on_next_level")
	$Win_PopUp/PopUP/Buttons/StartButton3.connect("pressed", self, "_on_exit")


func _on_next_level():
	GameFlow.load_next_level()
	queue_free()


func _on_exit():
	GameFlow.exit_game()

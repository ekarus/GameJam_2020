extends CanvasLayer


func _ready():
	$Win_PopUp/PopUP/Buttons/StartButton2.connect("pressed", self, "_on_next_level")
	$Win_PopUp/PopUP/Buttons/StartButton4.connect("pressed", self, "_on_exit")
	$Win_PopUp.modulate = Color(255, 255, 255, 0)
	$AnimationPlayer.play("Panel_open")


func _on_next_level():
	GameFlow.load_first_level()
	GameFlow.unlock_character_input()
	queue_free()


func _on_exit():
	GameFlow.exit_game()

extends Control


func _ready():
	$Loose_PopUp/PopUp/Buttons/StartButton.connect("pressed", self, "_on_continue")
	$Loose_PopUp/PopUp/Buttons/StartButton3.connect("pressed", self, "_on_exit")


func _on_continue():
	GameFlow.unlock_character_input()
	queue_free()


func _on_exit():
	GameFlow.exit_game()

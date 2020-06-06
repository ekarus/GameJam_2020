extends GameLevel

func _ready():
	_game_hud.hide()
	GameFlow.lock_character_input()
	$CanvasLayer/MainMenu.connect("start_game", self, "_on_StartButton_pressed")
	

func _on_StartButton_pressed():
	GameFlow.unlock_character_input()
	_game_hud.show()
	$Player.reset_hunger(1.0)
	$CanvasLayer/MainMenu.hide()

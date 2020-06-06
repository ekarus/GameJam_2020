extends GameLevel


func _ready():
	Events.connect("start_game", self, "start_new_game")
	if GameFlow.main_menu_instance != null and GameFlow.main_menu_instance.visible:
		GameFlow.hide_hud()
		GameFlow.lock_character_input()


func start_new_game():
	$Player.reset_hunger(1.0)
	GameFlow.show_hud()
	GameFlow.unlock_character_input()

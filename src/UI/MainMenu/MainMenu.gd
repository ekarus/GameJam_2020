extends Control


func _ready():
	$Buttons/StartButton.connect("pressed", self, "start_game")
	$Buttons/StartButton.grab_focus()
		

func start_game():
	Events.emit_signal("start_game")
	hide()
	
	
func show():
	visible = true


func hide():
	visible = false

extends Control


signal start_game


func _ready():
	$Buttons/StartButton.connect("pressed", self, "emit_signal", ["start_game"])
	$Buttons/StartButton.grab_focus()

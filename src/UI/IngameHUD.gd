extends CanvasLayer

onready var hungry_bar : ProgressBar = $"Hungry Hud"

func _ready():
	Events.connect("player_hunger_changed", self, "set_hungry_value")

func hide():
	$MoveSelectionPanel.visible = false
	hungry_bar.visible = false
		
func show():
	$MoveSelectionPanel.visible = true
	hungry_bar.visible = true

func set_hungry_value(value):
	value = clamp(value, hungry_bar.min_value, hungry_bar.max_value)
	hungry_bar.value = value
	
func get_hungry_value():
	return hungry_bar.value

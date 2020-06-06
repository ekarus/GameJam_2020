extends CanvasLayer

onready var panel = $DialogPanel

export (Dictionary) var DIALOGS = { }

func _ready():
	_set_active(false)

func _set_active(value):
	panel.visible = value
	pass
	
func _get_active():
	return panel.visible
	
func _get_text_label():
	if panel != null:
		return panel.get_child(0)
	else:
		return null
	
func show_dialog(key, wait_time : float):
	_set_active(true)
	var label : Label = _get_text_label()
	label.text = DIALOGS[key] as String
	$Timer.wait_time = wait_time
	$Timer.start()

	
func hide_dialog():
	_set_active(false)
	pass


func _on_Timer_timeout():
	hide_dialog()
	pass # Replace with function body.



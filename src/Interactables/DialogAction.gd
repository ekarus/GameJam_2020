extends TriggerAction
class_name DialogAction

export var dialogLine = "test_dialog"
export var dialogTime = 1.2

func process_action():
	DialogController.show_dialog(dialogLine, dialogTime)
	pass

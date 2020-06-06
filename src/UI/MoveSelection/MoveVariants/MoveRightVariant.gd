extends Node2D


func _ready():
	var count = randi() % 4 + 1
	$VariantBase.steps_count = count
	if count > 1 and $Control != null:
		$Control.show()
		$Control/Label2.text = ("%s" % count)
	else:
		$Control.hide()

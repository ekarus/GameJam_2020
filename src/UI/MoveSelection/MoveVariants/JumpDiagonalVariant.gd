extends Node2D


func _ready():
	var count = randi() % 4 + 1
	$VariantBase.steps_count = count
	if count > 0:
		$Label.text = $Label.text + (" x%s" % count)

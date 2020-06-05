extends Node2D


func _ready():
	var count = randi() % 4 + 1
	$VariantBase.steps_count = count
	if count > 1:
		$Label.text = $Label.text + (" x%s" % count)

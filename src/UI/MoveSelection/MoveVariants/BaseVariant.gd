class_name BaseVariant
extends Node2D


func get_index_from_progression(progression):
	var progression_sum = 0
	for value in progression:
		progression_sum += value
	
	var pos = randi() % progression_sum
	
	for i in range(progression.size()):
		pos -= progression[i]
		if pos <= 0:
			return i
	
	print("this random stuff is broken")
	return 0


func update_count(progression):
	var count = get_index_from_progression(progression) + 1
	
	$VariantBase.steps_count = count
	if count > 1 and $Control != null:
		$Control.show()
		$Control/Label2.text = ("%s" % count)
	else:
		$Control.hide()
	return count


func activate_effect():
	scale = Vector2(1.3, 1.3)
	$Normal.set_visible(false)
	$Activated.set_visible(true)

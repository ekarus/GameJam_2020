extends BaseBehavior
class_name BehaviorLoop

export var MOVE_DIRECTION = Vector2.ZERO
export var MOVE_OFFSET = 50
var shouldMove = false

func _internal_process():
	if !shouldMove:
		$Tween.interpolate_property(body, "position",
			body.position, body.position + MOVE_DIRECTION * MOVE_OFFSET, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		shouldMove = true
	pass

func lerp(a, b, t):
	return (1 - t) * a + t * b


func _on_tween_completed(object, key):
	shouldMove = false
	MOVE_DIRECTION = -MOVE_DIRECTION
	pass # Replace with function body.

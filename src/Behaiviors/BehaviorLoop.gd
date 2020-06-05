extends BaseBehavior
class_name BehaviorLoop

export var MOVE_DIRECTION = Vector2.ZERO
export var MOVE_OFFSET = 50
export var MOVE_SPEED = 200
var start_position = Vector2.ZERO
var side = -1
var shouldMove = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if shouldMove && body.global_position < start_position - (MOVE_OFFSET * side * MOVE_DIRECTION):
		body.global_position -= (side * MOVE_DIRECTION) * MOVE_SPEED * delta
	else:
		shouldMove = false
		side = -side
	pass

func _internal_process():
	start_position = body.global_position
	shouldMove = true
	pass

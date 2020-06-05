class_name Enemy
extends Actor

enum State {
	IDLE,
	WALKING,
	DEAD
}

enum Direction {
	RIGHT,
	LEFT
}

export(State) var _state = State.IDLE setget _set_state
export(Direction) var _direction = Direction.RIGHT setget _set_direction
export var _speed = 100
export var _stepSize = 16

var _distance = 0
var _startPosition = Vector2.ZERO
var _is_falling = false

onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var sprite = $Sprite

func _ready():
	Events.connect("player_action_choosen", self, "_on_process_action")

func _on_process_action(action, steps):
	self._direction = _change_direction_on_collision(_direction)
	self._distance = _stepSize * steps
	self._startPosition = self.global_position
	self._state = State.WALKING

func _process(delta):
	pass

func _physics_process(_delta):
	# platform collision
	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE 
	var is_falling = not platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(_velocity, snap_vector, FLOOR_NORMAL, is_falling, 4, 0.9, false)
	
	# debug utility
	if _is_falling != is_falling:
#		if is_falling:
#			print_debug("Begin falling")
#		else:
#			print_debug("End falling")
		_is_falling = is_falling
	
	# should we stop already?
	if _state == State.WALKING && not is_falling && abs(self.global_position.x - _startPosition.x) >= _distance:
		self._state = State.IDLE

	var animation = _select_animation()
	if animation != sprite.animation:
		#print_debug("Switching animation to " + animation)
		sprite.play(animation)

func _change_direction_on_collision(_direction):
	if is_on_wall():
		#print_debug("Wall detected")
		if _direction == Direction.LEFT:
			return Direction.RIGHT
		else:
			return Direction.LEFT

#	if _direction == Direction.LEFT && not floor_detector_left.is_colliding():
#		print_debug("Left edge detected")
#		return Direction.RIGHT
#
#	if _direction == Direction.RIGHT && not floor_detector_right.is_colliding():
#		print_debug("Right edge detected")
#		return Direction.LEFT

	return _direction

func _select_animation():
	if _state == State.WALKING && abs(_velocity.x) != 0:
		return "Walk"
	return "Idle"

func _set_state(value):
	if value == State.WALKING:
		#print_debug("Switching state to WALKING")
		if _direction == Direction.LEFT:
			_velocity.x = -_speed
		elif _direction == Direction.RIGHT:
			_velocity.x = _speed
		else:
			_velocity.x = 0
	elif value == State.IDLE:
		#print_debug("Switching state to IDLE")
		_velocity.x = 0
	_state = value

func _set_direction(value):
	if sprite != null:
		sprite.flip_h = (value == Direction.RIGHT)
	else:
		print_debug("Bug?")
	_direction = value


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
export var _step_size = 16
export var _stop_on_edge = false
export var _follow_player = false
export var _player_visibility_radius = 256

var _distance = 0
var _start_position = Vector2.ZERO
var _is_falling = false

onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var sprite = $Sprite

func _ready():
	Events.connect("player_action_choosen", self, "_on_process_action")

func _on_process_action(action, steps):
	self._direction = _select_direction(_direction)
	self._distance = _step_size * steps
	self._start_position = self.global_position
	self._state = State.WALKING

func _process(delta):
	pass

func _physics_process(_delta):
	# platform collision
	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE 
	var is_falling = not platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(_velocity, snap_vector, FLOOR_NORMAL, is_falling, 4, 0.9, false)
	
	# should we stop already?
	if _state == State.WALKING && abs(self.global_position.x - _start_position.x) >= _distance:
		self._state = State.IDLE

func _select_direction(_direction):
	if _follow_player:
		#print_debug("Should following player!")
		var level = GameFlow.current_level
		if level != null && level.player != null:
			var distance = self.global_position.distance_to(level.player.global_position)
			#print_debug("Distance to the player: ", distance)
			if distance <= _player_visibility_radius:
				var direction = self.global_position.direction_to(level.player.global_position)
				#print_debug("Player's direction: ", direction)
				if direction.x < 0:
					return Direction.LEFT
				else:
					return Direction.RIGHT
	return _change_direction_on_collision(_direction)

func _change_direction_on_collision(_direction):
	if is_on_wall():
		#print_debug("Wall detected")
		if _direction == Direction.LEFT:
			return Direction.RIGHT
		else:
			return Direction.LEFT

	if _stop_on_edge:
		if _direction == Direction.LEFT && not floor_detector_left.is_colliding():
			#print_debug("Left edge detected")
			return Direction.RIGHT
		if _direction == Direction.RIGHT && not floor_detector_right.is_colliding():
			#print_debug("Right edge detected")
			return Direction.LEFT

	return _direction

func _set_state(value):
	_state = value
	if _state == State.WALKING:
		#print_debug("Switching state to WALKING")
		if _direction == Direction.LEFT:
			_velocity.x = -_speed
		elif _direction == Direction.RIGHT:
			_velocity.x = _speed
		else:
			_velocity.x = 0
	elif _state == State.IDLE:
		#print_debug("Switching state to IDLE")
		_velocity.x = 0
	# select animation according to the current state
	var animation = _select_animation()
	if animation != sprite.animation:
		#print_debug("Switching animation to " + animation)
		sprite.play(animation)

func _select_animation():
	if _state == State.WALKING && abs(_velocity.x) != 0:
		return "Walk"
	return "Idle"

func _set_direction(value):
	_direction = value
	if sprite != null:
		sprite.flip_h = (_direction == Direction.RIGHT)


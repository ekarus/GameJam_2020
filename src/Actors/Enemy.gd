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
export var _step_size = 64
export var _stop_on_edge = false
export var _follow_player = false
export var _player_visibility_radius = 256

var _distance = 0
var _start_position = Vector2.ZERO

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


func _on_StompDetector_body_entered(body: Node) -> void:
	if body.global_position.y > $StompDetector.global_position.y:
		return
	$CollisionShape2D.disabled = true
	queue_free()


func _process(delta):
	pass


func _physics_process(_delta):
	# platform collision
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
#	var collision = move_and_collide(_velocity * _delta)
#	if collision:
#		_velocity = _velocity.slide(collision.normal)
	
	# did we hit something?
#	if _velocity.x == 0:
#		print(self.name, " hit something")
#		_state = State.IDLE
	
	# should we stop already?
	if _state == State.WALKING && abs(self.global_position.x - _start_position.x) >= _distance:
		self._state = State.IDLE

	# nothing to animate yet
	if sprite == null:
		return

	# select animation according to the current state
	var animation = _select_animation()
	if animation != sprite.animation:
		#print(self.name, " switching animation to: " + animation)
		sprite.play(animation)


func _select_direction(_direction):
	if _follow_player:
		var level = GameFlow.current_level
		if level != null && level.player != null:
			var distance = self.global_position.distance_to(level.player.global_position)
			if distance <= _player_visibility_radius:
				var direction = self.global_position.direction_to(level.player.global_position)
				if direction.x < 0:
					print(self.name, " sees player on the left, direction: ", direction)
					return Direction.LEFT
				else:
					print(self.name, " sees player on the right, direction: ", direction)
					return Direction.RIGHT
			else:
				print(self.name, " doesn't see player, distance: ", distance)
	return _change_direction_on_collision(_direction)


func _change_direction(_direction):
	if _direction == Direction.LEFT:
		return Direction.RIGHT
	else:
		return Direction.LEFT


func _change_direction_on_collision(_direction):
	if is_on_wall():
		print(self.name, " wall detected")
		return _change_direction(_direction)

	if _stop_on_edge:
		if _direction == Direction.LEFT && not floor_detector_left.is_colliding():
			print(self.name, " left edge detected")
			return Direction.RIGHT
		if _direction == Direction.RIGHT && not floor_detector_right.is_colliding():
			print(self.name, " right edge detected")
			return Direction.LEFT

	return _direction


func _set_state(value):
	_state = value
	if _state == State.WALKING:
		if _direction == Direction.LEFT:
			print(self.name, " is going to WALK LEFT")
			_velocity.x = -_speed
		else:
			print(self.name, " is going to WALK RIGHT")
			_velocity.x = _speed
	elif _state == State.IDLE:
		print(self.name, " is going to IDLE")
		_velocity.x = 0


func _select_animation():
	if _state == State.WALKING && abs(_velocity.x) != 0:
		return "Walk"
	return "Idle"


func _set_direction(value):
	_direction = value
	if sprite == null:
		return
	sprite.flip_h = (_direction == Direction.RIGHT)


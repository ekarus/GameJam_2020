class_name Enemy
extends Actor

enum State {
	IDLE,
	WALK
}

enum Direction {
	RIGHT,
	LEFT
}

export(Direction) var _direction = Direction.LEFT setget _set_direction
var _state = State.IDLE setget _set_state

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
	if _follow_player:
		self._direction = _select_direction(_direction)
	self._distance = _step_size * steps
	self._start_position = self.global_position
	self._state = State.WALK


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

	if not _follow_player:
		self._direction = _change_direction_on_collision(_direction)
	
	if _stop_on_edge:
		self._direction = _change_direction_on_edge(_direction)
	
	if _state == State.WALK:
		# if walked far enought
		if abs(self.global_position.x - _start_position.x) >= _distance:
			self._state = State.IDLE
		# or hit something
		elif _velocity.x == 0:
			self._state = State.IDLE


func _select_direction(_direction):
	var level = GameFlow.current_level
	if level != null && level.player != null:
		var distance = self.global_position.distance_to(level.player.global_position)
		if distance <= _player_visibility_radius:
			var direction = self.global_position.direction_to(level.player.global_position)
			if direction.x < 0:
#				print(self.name, " sees player on the left, direction: ", direction)
				return Direction.LEFT
			else:
#				print(self.name, " sees player on the right, direction: ", direction)
				return Direction.RIGHT
		else:
#			print(self.name, " doesn't see player, distance: ", distance)
			pass
	return _direction


func _change_direction(_direction):
	_velocity.x = 0
	if _direction == Direction.LEFT:
		return Direction.RIGHT
	else:
		return Direction.LEFT


func _change_direction_on_collision(direction):
	if is_on_wall():
		print(self.name, " found detected")
		return _change_direction(direction)

	return direction


func _change_direction_on_edge(direction):
	if direction == Direction.LEFT && not floor_detector_left.is_colliding():
		print(self.name, " left edge detected")
		_velocity.x = 0
		return Direction.RIGHT
		
	if direction == Direction.RIGHT && not floor_detector_right.is_colliding():
		print(self.name, " right edge detected")
		_velocity.x = 0
		return Direction.LEFT

	return direction


func _set_state(value):
	if _state != value:
		_state = value
		_update_velocity()

	# nothing to animate yet
	if sprite == null:
		return

	# select animation according to the current state
	var animation = _select_animation()
	if animation != sprite.animation:
		#print(self.name, " switching animation to: " + animation)
		sprite.play(animation)


func _set_direction(value):
	if _direction != value:
		_direction = value
	
	if sprite == null:
		return
	sprite.flip_h = (_direction == Direction.RIGHT)


func _select_animation():
	if _state == State.WALK && abs(_velocity.x) != 0:
		return "Walk"
	return "Idle"


func _update_velocity():
	if _state == State.WALK:
		if _direction == Direction.LEFT:
			_velocity.x = -speed.x
		else:
			_velocity.x = speed.x
	else:
		_velocity.x = 0

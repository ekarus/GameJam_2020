class_name Enemy
extends Actor

enum State {
	IDLE,
	MOVE
}

enum Direction {
	RIGHT,
	LEFT
}

export(Direction) var _direction = Direction.LEFT setget _set_direction
var _state = State.IDLE setget _set_state
var _sees_player = false
var _hit_a_wall = false

const _epsilon = 4

onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var sprite = $Sprite

func _ready():
	Events.connect("player_action_choosen", self, "_on_process_action")


func _on_process_action(action, steps):
	if is_static_actor:
		return
	_sees_player = find_path()
	if not _sees_player:
		if _hit_a_wall:
			change_direction()
			_hit_a_wall = false
		go_straight()
	self._state = State.MOVE


func _on_StompDetector_body_entered(body: Node) -> void:
	if body.global_position.y > $StompDetector.global_position.y:
		return
	$CollisionShape2D.disabled = true
	var level = GameFlow.current_level
	if level:
		# remove debug info
		level.enemies_paths.erase(self.name)
		# redraw debug info
		level.update()
	Events.emit_signal("enemy_death", global_position)
	queue_free()


func _on_LeftKillDetector_body_entered(body: Node) -> void:
	_kill_player(body as Player)


func _on_RightKillDetector_body_entered(body: Node) -> void:
	_kill_player(body as Player)


func _kill_player(player: Player):
	if player:
		player.on_damage()


func _process(delta):
	pass


func _physics_process(delta):
	if is_static_actor:
		return
	if not process_active_action(delta):
		self._state = State.IDLE
	if not _hit_a_wall:
		_hit_a_wall = is_on_wall()
		if _hit_a_wall:
			print(self.name, " hit a wall, may change direction");


func find_path():
	var level = GameFlow.current_level
	if level == null || level.player == null:
		return false

	var nav = get_parent().get_node("Navigation2D")
	if nav == null:
		return false

	var path = nav.get_simple_path(self.position, level.player.position)
	# set debug info
	level.enemies_paths[self.name] = path
	# redraw debug info
	level.update()

	if path.size() < 2:
		return false
	
	var player_on_left = (path[0].x - path[1].x) >= _epsilon
	var player_on_right = (path[1].x - path[0].x) >= _epsilon
	var player_on_top = (path[0].y - path[1].y) >= _epsilon
	if player_on_top:
		if player_on_left:
			set_active_action(MoveVariantBase.VariantType.JumpLeft, 1)
		elif player_on_right:
			set_active_action(MoveVariantBase.VariantType.JumpRight, 1)
		elif path.size() > 2:
			player_on_left = (path[1].x - path[2].x) >= _epsilon
			player_on_right = (path[2].x - path[1].x) >= _epsilon
			if player_on_left:
				set_active_action(MoveVariantBase.VariantType.JumpLeft, 1)
			elif player_on_right:
				set_active_action(MoveVariantBase.VariantType.JumpRight, 1)
	else:
		if player_on_left:
			set_active_action(MoveVariantBase.VariantType.Left, 1)
		elif player_on_right:
			set_active_action(MoveVariantBase.VariantType.Right, 1)
		else:
			print(self.name, ": what is going on???")
	
	if player_on_left:
		self._direction = Direction.LEFT
	elif player_on_right:
		self._direction = Direction.RIGHT
	return true


func go_straight():
	if _direction == Direction.LEFT:
		set_active_action(MoveVariantBase.VariantType.Left, 1)
	else:
		set_active_action(MoveVariantBase.VariantType.Right, 1)


func change_direction():
	if _direction == Direction.LEFT:
		self._direction = Direction.RIGHT
	else:
		self._direction = Direction.LEFT


func select_animation():
	if _state == State.MOVE && abs(movement_dir.x) != 0:
		return "Move"
	return "Idle"


func _set_state(value):
	if _state != value:
		_state = value

	# nothing to animate yet
	if sprite == null:
		return

	# select animation according to the current state
	var animation = select_animation()
	if animation != sprite.animation:
		#print(self.name, " switching animation to: " + animation)
		sprite.play(animation)


func _set_direction(value):
	if _direction != value:
		_direction = value

	if sprite:
		sprite.flip_h = (_direction == Direction.RIGHT)

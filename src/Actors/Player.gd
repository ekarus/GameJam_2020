class_name Player
extends Actor

onready var platform_detector = $PlatformDetector
onready var sprite = $AnimatedSprite

export var speed = 100
export var jump_speed = 100

var movement_dir = Vector2()

var active_action = null
var active_action_steps = 0
var step_length = 2
var discrete_move_done = false
var current_step_time_left = step_length

var lastHorisontalDirection = 1

var move_selection_panel_pos = Vector2()

func _ready():
	Events.connect("player_action_choosen", self, "_on_action_choosen")
	move_selection_panel_pos = $MoveSelectionPanel.position


func _process(delta):
	# process steps time calculation
	if active_action != null:
		current_step_time_left -= delta
		if current_step_time_left < 0:
			active_action_steps -= 1
			discrete_move_done = false
			current_step_time_left = step_length
			
			if active_action_steps <= 0:
				active_action = null
	
	_process_action_input()
	
	# just for test
	# _process_normal_input()
	
	$MoveSelectionPanel.set_global_position(clamp_vec(
		move_selection_panel_pos + get_global_position(),
		Vector2($Camera2D.limit_left, $Camera2D.limit_top),
		Vector2($Camera2D.limit_right, $Camera2D.limit_bottom)))


func _process_normal_input():
	var desiredDirection = Vector2()
	
	if Input.is_action_pressed("move_left"):
		desiredDirection.x += -1
	if Input.is_action_pressed("move_right"):
		desiredDirection.x += 1
	if Input.is_action_just_pressed("jump") and is_on_floor():
		desiredDirection.y += -1
	
	movement_dir = desiredDirection


func _process_action_input():
	if active_action == null:
		movement_dir = Vector2()
		return
	
	var desiredDirection = Vector2()
	
	if active_action == MoveVariantBase.VariantType.Left:
		desiredDirection.x = -1
	elif active_action == MoveVariantBase.VariantType.Right:
		desiredDirection.x = 1
	elif active_action == MoveVariantBase.VariantType.JumpUp and is_on_floor():
		desiredDirection.y = -1
	elif active_action == MoveVariantBase.VariantType.JumpDiagonal:
		if not discrete_move_done and is_on_floor():
			desiredDirection.y = -1
			discrete_move_done = true
		desiredDirection.x = lastHorisontalDirection
	
	if desiredDirection.x > 0:
		lastHorisontalDirection = 1
		sprite.scale.x = 1
	elif desiredDirection.x < 0:
		lastHorisontalDirection = -1
		sprite.scale.x = -1
	
	movement_dir = desiredDirection


func _on_action_choosen(action, steps):
	active_action = action
	active_action_steps = steps
	current_step_time_left = step_length
	discrete_move_done = false


func _physics_process(delta):
	# super call
	._physics_process(delta)
	
	# input acceleration
	_velocity.x = speed * movement_dir.x
	if movement_dir.y != 0.0:
		_velocity.y = jump_speed * movement_dir.y
	
	# platform collision
	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if movement_dir.y == 0.0 else Vector2.ZERO
	var is_falling = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(_velocity, snap_vector, Vector2.UP, is_falling, 4, 0.9, false)


func on_damage():
	Events.emit_signal("player_died")


func clamp_vec(vector, min_v, max_v):
	return Vector2(clamp(vector.x, min_v.x, max_v.x), clamp(vector.y, min_v.y, max_v.y))

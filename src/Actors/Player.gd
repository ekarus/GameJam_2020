class_name Player
extends Actor

onready var platform_detector = $PlatformDetector
onready var sprite = $AnimatedSprite

var movement_dir = Vector2()

var active_action = null
var active_action_steps = 0
const move_step_length = 3
const jump_step_length = 6

var discrete_move_done = false
var current_step_length = move_step_length
var current_step_time_left = current_step_length

const step_size = 16.0

var hunger_level = 1.0
var hunger_speed = 0.1

var move_selection_panel_pos = Vector2()

var prevVelY = 0.0
var playerDied = false

func _ready():
	Events.connect("player_action_choosen", self, "_on_action_choosen")


func _process(delta):
	if !playerDied:
		# process steps time calculation
		if active_action != null:
			current_step_time_left -= delta
			if current_step_time_left < 0 and is_on_floor():
				active_action_steps -= 1
				discrete_move_done = false
				current_step_time_left = current_step_length
				
				if active_action_steps <= 0:
					active_action = null
					Events.emit_signal("player_action_complete")
		
		_process_action_input()

		# just for test
		# _process_normal_input()
		
		hunger_level -= hunger_speed * delta
		if hunger_level <= 0:
			on_damage()
		Events.emit_signal("player_hunger_changed", hunger_level * 100)
	_update_animations()

func _update_animations():
	
	if playerDied:
		$AnimatedSprite.play("hit")
		return
		
	var is_moving = abs(movement_dir.x) > 0
	var is_jumping = _velocity.y < 0
	var is_falling = prevVelY - _velocity.y < 0
	
	if is_jumping && !$Jump_sound.playing:
		$Jump_sound.play()
	
	if is_moving:
		$AnimatedSprite.play("run")
	elif is_jumping:
		$AnimatedSprite.play("jump")
	elif is_falling:
		$AnimatedSprite.play("fall")
	else:
		$AnimatedSprite.play("idle")

	prevVelY = _velocity.y
	pass


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
	
	if active_action in [MoveVariantBase.VariantType.Left, MoveVariantBase.VariantType.JumpLeft]:
		desiredDirection.x = -1
	elif active_action in [MoveVariantBase.VariantType.Right, MoveVariantBase.VariantType.JumpRight]:
		desiredDirection.x = 1
	elif active_action == MoveVariantBase.VariantType.JumpUp:
		if not discrete_move_done and is_on_floor():
			desiredDirection.y = -1
			discrete_move_done = true

	if active_action in [MoveVariantBase.VariantType.JumpLeft, MoveVariantBase.VariantType.JumpRight]:
		if not discrete_move_done and is_on_floor():
			desiredDirection.y = -1
			discrete_move_done = true
	
	if desiredDirection.x > 0:
		sprite.scale.x = 1
	elif desiredDirection.x < 0:
		sprite.scale.x = -1
	
	movement_dir = desiredDirection


func _on_action_choosen(action, steps):
	if active_action != null:
		print("skipped action because processing another one")
		return
	
	$choose_sound.play()
	
	active_action = action
	active_action_steps = steps
	
	if active_action == MoveVariantBase.VariantType.Left or active_action == MoveVariantBase.VariantType.Right:
		current_step_length = move_step_length * step_size / speed.x
	else:
		current_step_length = jump_step_length * step_size / speed.x
	
	current_step_time_left = current_step_length
	discrete_move_done = false


func _physics_process(delta):
	# input acceleration
	_velocity.x = speed.x * movement_dir.x
	if movement_dir.y != 0.0:
		_velocity.y = speed.y * movement_dir.y
	
	# platform collision
	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if movement_dir.y == 0.0 else Vector2.ZERO
	var is_falling = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(_velocity, snap_vector, Vector2.UP, is_falling, 4, 0.9, false)


func reduce_hunger(value):
	hunger_level += value
	pass


func reset_hunger(value):
	hunger_level = 1.0


func on_damage():
	if playerDied:
		return
	
	Events.emit_signal("player_died")
	playerDied = true
	print_debug("player is ded")

	pass


func clamp_vec(vector, min_v, max_v):
	print("orig: ", vector)
	print("min: ", min_v)
	print("max: ", max_v)
	print("res: ", Vector2(clamp(vector.x, min_v.x, max_v.x), clamp(vector.y, min_v.y, max_v.y)))
	return Vector2(clamp(vector.x, min_v.x, max_v.x), clamp(vector.y, min_v.y, max_v.y))


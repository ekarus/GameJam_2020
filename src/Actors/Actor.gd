class_name Actor
extends KinematicBody2D

# Both the Player and Enemy inherit this scene as they have shared behaviours
# such as speed and are affected by gravity.

onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

const FLOOR_NORMAL = Vector2.UP
const FLOOR_DETECT_DISTANCE = 20.0

const move_step_length = 3
const jump_step_length = 6
const step_size = 16.0

export var speed: = Vector2(100, 190)
export var is_static_actor = false

var velocity: = Vector2.ZERO
var movement_dir = Vector2()

var active_action = null
var active_action_steps = 0

var discrete_move_done = false
var current_step_length = move_step_length
var current_step_time_left = current_step_length


# _physics_process is called after the inherited _physics_process function.
# This allows the Player and Enemy scenes to be affected by gravity.
func _physics_process(delta):
	# input acceleration
	velocity.x = speed.x * movement_dir.x
	if movement_dir.y != 0.0:
		velocity.y = speed.y * movement_dir.y
	
	if is_static_actor:
		return
	
	# platform collision
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	velocity.y += gravity * delta


func set_active_action(action, steps):
	if active_action != null:
		print("skipped action because processing another one")
		return
	
	active_action = action
	active_action_steps = steps
	
	if active_action == MoveVariantBase.VariantType.Left or active_action == MoveVariantBase.VariantType.Right:
		current_step_length = move_step_length * step_size / speed.x
	else:
		current_step_length = jump_step_length * step_size / speed.x
	
	current_step_time_left = current_step_length
	discrete_move_done = false


func process_active_action(delta):
	# process steps time calculation
	if active_action != null:
		current_step_time_left -= delta
		
		if current_step_time_left < 0 and is_on_floor():
			active_action_steps -= 1
			discrete_move_done = false
			current_step_time_left = current_step_length
			
			if active_action_steps <= 0:
				active_action = null
					
	if active_action == null:
		movement_dir = Vector2()
		return false
	
	var desired_direction = Vector2()
	
	if active_action in [MoveVariantBase.VariantType.Left, MoveVariantBase.VariantType.JumpLeft]:
		desired_direction.x = -1
	elif active_action in [MoveVariantBase.VariantType.Right, MoveVariantBase.VariantType.JumpRight]:
		desired_direction.x = 1
	elif active_action == MoveVariantBase.VariantType.JumpUp:
		if not discrete_move_done and is_on_floor():
			desired_direction.y = -1
			discrete_move_done = true

	if active_action in [MoveVariantBase.VariantType.JumpLeft, MoveVariantBase.VariantType.JumpRight]:
		if not discrete_move_done and is_on_floor():
			desired_direction.y = -1
			discrete_move_done = true
	
	movement_dir = desired_direction
	return true


func on_damage():
	print("%s received damage" % name)



class_name Player
extends KinematicBody2D

onready var platform_detector = $PlatformDetector

export var speed = 100
export var jump_speed = 100
onready var gravity = 100

var velocity = Vector2()

const FLOOR_DETECT_DISTANCE = 20.0

var movement_dir = Vector2()

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _process_input():
	var desiredDirection = Vector2()
	
	if Input.is_action_pressed("move_left"):
		desiredDirection.x += -1
	if Input.is_action_pressed("move_right"):
		desiredDirection.x += 1
	if Input.is_action_just_pressed("jump") and is_on_floor():
		desiredDirection.y += -1
	
	movement_dir = desiredDirection
	
	pass


func _physics_process(delta):
	# just for test
	_process_input()
	
	# gravity acceleration
	velocity.y += gravity * delta
	
	# input acceleration
	velocity.x = speed * movement_dir.x
	if movement_dir.y != 0.0:
		velocity.y = jump_speed * movement_dir.y
	
	# platform collision
	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if movement_dir.y == 0.0 else Vector2.ZERO
	var is_falling = platform_detector.is_colliding()
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, is_falling, 4, 0.9, false)

func _apply_damage():
	Events.emit_signal("player_died")
	pass

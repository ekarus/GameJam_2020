class_name Player
extends Actor

onready var platform_detector = $PlatformDetector
onready var sprite = $AnimatedSprite

var hunger_level = 1.0
var hunger_speed = 0.1

var move_selection_panel_pos = Vector2()

var prev_velocity = 0.0
var is_dead = false

func _ready():
	Events.connect("player_action_choosen", self, "_on_action_choosen")


func _process(delta):
	pass


func _physics_process(delta):
	if !is_dead:
		# process steps time calculation
		if active_action != null:
			process_active_action(delta)
			if active_action == null:
				Events.emit_signal("player_action_complete")
		
		if movement_dir.x > 0:
			sprite.scale.x = 1
		elif movement_dir.x < 0:
			sprite.scale.x = -1

		if !GameFlow.is_main_menu_open():
			hunger_level -= hunger_speed * delta
			if hunger_level <= 0:
				on_damage()
			Events.emit_signal("player_hunger_changed", hunger_level * 100)
	_update_animations()

func _update_animations():
	
	if is_dead:
		play_animation("hit")
		return
		
	var is_moving = abs(movement_dir.x) > 0
	var is_jumping = velocity.y < 0
	var is_falling = prev_velocity - velocity.y < 0
	
	if is_jumping && !$Jump_sound.playing:
		$Jump_sound.play()
	
	if is_moving:
		play_animation("run")
	elif is_jumping:
		play_animation("jump")
	elif is_falling:
		play_animation("fall")
	else:
		play_animation("idle")

	prev_velocity = velocity.y
	pass


func play_animation(name):
	if sprite.animation != name:
		sprite.play(name)


func _on_action_choosen(action, steps):
	$choose_sound.play()
	set_active_action(action, steps)


func reduce_hunger(value):
	hunger_level += value
	pass


func reset_hunger(value):
	hunger_level = 1.0


func on_damage():
	if is_dead:
		return
	
	Events.emit_signal("player_died")
	is_dead = true
	print("Player died!")

	pass


func clamp_vec(vector, min_v, max_v):
	print("orig: ", vector)
	print("min: ", min_v)
	print("max: ", max_v)
	print("res: ", Vector2(clamp(vector.x, min_v.x, max_v.x), clamp(vector.y, min_v.y, max_v.y)))
	return Vector2(clamp(vector.x, min_v.x, max_v.x), clamp(vector.y, min_v.y, max_v.y))


extends Node2D

var spawn_timer = Timer.new()
var rng = RandomNumberGenerator.new()

var variant_scenes = [
	preload("res://src/UI/MoveSelection/MoveVariant.tscn")
]

var active_variants = []

# variants per screen per second
var start_speed = 100
var speed = start_speed
# multiplier (abstract number)
var minimum_spawn_speed = 0.1

# average variants count on screen
var variants_dencity = 5

func _ready():
	rng.randomize()
	
	spawn_timer.set_one_shot(true)
	spawn_timer.connect("timeout", self, "_spawn_new_variant")
	add_child(spawn_timer)
	
	_spawn_new_variant()


func _process(delta):
	if Input.is_action_just_pressed("select_action"):
		_select_hovered_action()
		pass
	#elif Input.is_action_pressed("select_action"):
	#	pass
	
	_update_positions(delta)
	
	_despawn_old_variants()


func _spawn_new_variant():
	# restart timer
	# ToDo: better randomization that takes speed into account
	spawn_timer.start(rng.randf_range(0.1, 1))
	
	# spawn
	var new_scene = variant_scenes[rng.randi_range(0, variant_scenes.size() - 1)]
	
	var node_instance = new_scene.instance()
	$VariantsContainer.add_child(node_instance)
	node_instance.set_global_position(position)
	active_variants.append(node_instance)


func _despawn_old_variants():
	var variants_to_despawn = []
	
	for variant in active_variants:
		if variant.position.y > 100:
			variants_to_despawn.append(variant)
	
	for variant in variants_to_despawn:
		active_variants.remove(active_variants.find(variant))
		$VariantsContainer.remove_child(variant)


func _update_positions(delta):
	for variant in active_variants:
		variant.position.y += speed * delta


func _select_hovered_action():
	pass

extends Node2D

var spawn_timer = Timer.new()
var rng = RandomNumberGenerator.new()

var variant_scenes = [
	preload("res://src/UI/MoveSelection/MoveVariants/MoveRightVariant.tscn"),
	preload("res://src/UI/MoveSelection/MoveVariants/MoveLeftVariant.tscn"),
	preload("res://src/UI/MoveSelection/MoveVariants/JumpDiagonalVariant.tscn"),
	preload("res://src/UI/MoveSelection/MoveVariants/JumpUpVariant.tscn")
]

var active_variants = []

var start_speed = 100.0
var speed = start_speed
var variant_spawn_height = 20.0
var variant_collision_height = 10.0

var scene_center
var scene_half_height
var item_collision_half_size

# for adjusting priority of subsequent variants
var variant_center_shift = 0

# average variants count on screen
var variants_dencity = 5

func _ready():
	rng.randomize()
	
	spawn_timer.set_one_shot(true)
	spawn_timer.connect("timeout", self, "_spawn_new_variant")
	add_child(spawn_timer)
	
	scene_center = $PanelArea/CollisionShape2D.position
	scene_half_height = ($PanelArea/CollisionShape2D.shape as RectangleShape2D).extents.y
	
	item_collision_half_size = ($Cursor/CollisionShape2D.shape as RectangleShape2D).extents.y + variant_collision_height/2
	
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
	spawn_timer.start(rng.randf_range(variant_spawn_height / speed, 1))
	
	# spawn
	var new_scene = variant_scenes[rng.randi_range(0, variant_scenes.size() - 1)]
	
	var node_instance = new_scene.instance()
	$VariantsContainer.add_child(node_instance)
	node_instance.position = Vector2(scene_center.x, scene_center.y - scene_half_height)
	active_variants.append(node_instance)


func _despawn_variant_items(variants_to_despawn):
	for variant in variants_to_despawn:
		active_variants.remove(active_variants.find(variant))
		$VariantsContainer.remove_child(variant)
		variant.queue_free()


func _despawn_old_variants():
	var variants_to_despawn = []
	
	for variant in active_variants:
		if variant.position.y > scene_center.y + scene_half_height + variant_spawn_height:
			variants_to_despawn.append(variant)
	
	_despawn_variant_items(variants_to_despawn)


func _update_positions(delta):
	for variant in active_variants:
		variant.position.y += speed * delta


func _select_hovered_action():
	var variant_to_activate = null
	var min_diff = item_collision_half_size
	
	for variant in active_variants:
		var pos_diff = abs(variant.get_global_position().y - $Cursor/CollisionShape2D.get_global_position().y + variant_center_shift)
		if pos_diff < min_diff:
			variant_to_activate = variant

	if variant_to_activate != null:
		var variant_base = variant_to_activate.get_node("VariantBase")
		_activate_action(variant_base.variant_type, variant_base.steps_count)
		_despawn_variant_items([variant_to_activate])


func _activate_action(action_type, steps):
	match action_type:
		MoveVariantBase.VariantType.Left:
			print("Left")
		MoveVariantBase.VariantType.Right:
			print("Right")
		MoveVariantBase.VariantType.JumpDiagonal:
			print("JumpDiagonal")
		MoveVariantBase.VariantType.JumpUp:
			print("JumpUp")
	
	Events.emit_signal("player_action_choosen", action_type, steps)


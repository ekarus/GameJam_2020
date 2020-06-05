extends Node
class_name BaseBehavior

var body : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("player_action_choosen", self, "_on_process_action")
	pass # Replace with function body.

func _process(delta):
	_internal_process()
	pass

func _on_process_action(movetype, steps):
	pass

func _internal_process():
	pass

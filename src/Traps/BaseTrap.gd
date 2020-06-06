extends Area2D
class_name Trap

onready var behaviour : BaseBehavior = $Behavior

# Called when the node enters the scene tree for the first time.
func _ready():
	behaviour.body = self
	connect("body_entered", self, "_on_Trap_body_entered")
	pass

func _on_Trap_body_entered(body):
	if body is Player:
		(body as Player).on_damage()
	pass 

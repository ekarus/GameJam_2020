extends Area2D

onready var behaviour : BaseBehavior = $Behavior

# Called when the node enters the scene tree for the first time.
func _ready():
	behaviour.body = self
	pass

func _on_Trap_body_entered(body):
	if body is Player:
		(body as Player)._apply_damage()
	pass 

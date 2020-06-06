extends Area2D
class_name Trigger

export (String) var GROUP_TO_INTERACT = "Player"

onready var action : TriggerAction = $Action

func _on_body_enter(body):
	if action != null && body.is_in_group(GROUP_TO_INTERACT):
		action.process_action()
	pass 

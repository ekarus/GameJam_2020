extends Control


func _ready():
	$ON.connect("pressed", self, "_on_disable")
	$OFF.connect("pressed", self, "_on_enable")
	print("ready")


func _on_enable():
	AudioServer.set_bus_mute(1, false)
	AudioServer.set_bus_mute(2, false)
	$ON.set_visible(true)
	$OFF.set_visible(false)
	


func _on_disable():
	AudioServer.set_bus_mute(1, true)
	AudioServer.set_bus_mute(2, true)
	$OFF.set_visible(true)
	$ON.set_visible(false)

# Autoloaded singleton that holds signals that would be troublesome to wire in a
# local parent or a scene owner.
# 
# This keeps objects passed through setup functions or unsafe accessors at a
# lower count, and can be replaced with simpler `Events.connect` calls.
extends Node

signal player_died
signal quit_requested

signal player_action_choosen

signal item_collected

signal level_completed
signal level_started
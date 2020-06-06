# Autoloaded singleton that holds signals that would be troublesome to wire in a
# local parent or a scene owner.
# 
# This keeps objects passed through setup functions or unsafe accessors at a
# lower count, and can be replaced with simpler `Events.connect` calls.
extends Node

signal player_died
signal quit_requested

signal player_action_choosen(move_type, steps)
signal player_action_complete
signal player_hunger_changed(value)

signal item_collected

signal level_completed
signal level_started
signal start_game

signal game_paused
signal game_unpaused

signal player_inactive_long_time
signal player_falling

signal enemy_death(position)

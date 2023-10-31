extends Node

var gems_collected = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("return_to_main_menu"):
		get_tree().change_scene_to_file("res://main_menu.tscn")
		Global.gems_collected = 0

func _reset_level():
	get_tree().reload_current_scene.call_deferred()
	Global.gems_collected = 0

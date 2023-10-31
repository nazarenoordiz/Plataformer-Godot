extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.play()
	$Options/StartButton.grab_focus()

	if not OS.has_feature("pc"):
		$Options/FullScreen.hide()
		$Options/QuitButton.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	$Music.stop()
	$WarpJingle.play()
	await(get_tree().create_timer(1).timeout)
	get_tree().change_scene_to_file("res://level_1.tscn")


func _on_full_screen_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_quit_button_pressed():
	get_tree().quit()

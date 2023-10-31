extends Node2D

@export var level_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD.level(level_num)
	$Music.play()
	set_coins_label()
	for coin in $Coins.get_children():
		coin.gem_collected.connect(_on_coin_collected)
	
		
	
func set_coins_label():
	$HUD.gems(Global.gems_collected)
	

func _on_coin_collected():
	set_coins_label()


func _on_door_player_entered(level):
	Engine.time_scale = 0.2
	$Music.stop()
	$WarpJingle.play()
	await(get_tree().create_timer(0.24).timeout)
	Engine.time_scale = 1
	get_tree().change_scene_to_file(level)

func _on_border_body_entered(body):
	if body.name == "Player":
		Engine.time_scale = 0.2
		$Music.stop()
		$DeathSound.play()
		await(get_tree().create_timer(0.24).timeout)
		Engine.time_scale = 1
		Global._reset_level()


func _input(event):
	if event.is_action_pressed("reset_level"):
		Global._reset_level()
		set_coins_label()



func _on_warp_jingle_finished():
	return true




extends Area2D

signal gem_collected

func _on_body_entered(body):
	if body.name == "Player":
		print_debug(Global.gems_collected)
		Global.gems_collected += 1
		gem_collected.emit()
		$CoinSfx.play()
		hide()


func _on_coin_sfx_finished():
	queue_free()

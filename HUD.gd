extends CanvasLayer

signal start_game
signal name_change

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func update_message(playerName):
	$MessageLabel.text = "Dodge the\nCreeps, " + playerName + "!"
	$MessageLabel.show()


func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Dodge the\nCreeps"
	$MessageLabel.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed():
	$StartButton.hide()
	$NameButton.hide()
	$LineEdit.hide()
	emit_signal("start_game")


func _on_NameButton_pressed():
	update_message($LineEdit.text)
	emit_signal("name_change", $LineEdit.text)


func _on_MessageTimer_timeout():
	$MessageLabel.hide()

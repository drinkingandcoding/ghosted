extends CanvasLayer

signal start_game
signal name_change

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_hint(text):
	$HintLabel.text = text
	$HintLabel.show()
	$HintTimer.start()

func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Survive"
	$MessageLabel.show()
	
	yield(get_tree().create_timer(1), "timeout")
	$ScoreList.hide()
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)


func update_time(time):
	$TimeLabel.text = str(time)


func sort_score(a, b):
	return a[1] > b[1]


func show_high_scores(highScores):
	var top = []
	for player in highScores:
		top.append([player, highScores[player]])
	top.sort_custom(self, "sort_score")
	$ScoreList.text = "Top Ghosts\n----------------------\n"
	for score in top.slice(0, 2):
		$ScoreList.text += score[0] + "\t" + str(score[1]) + "\n"
	$ScoreList.show()


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$MessageLabel.hide()


func _on_HintTimer_timeout():
	$HintLabel.hide()

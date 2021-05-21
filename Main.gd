extends Node

export(PackedScene) var mob_scene
export(PackedScene) var powerup_scene

var score
var time
var highScores

func _ready():
	randomize()
	Network.connect("player_list_changed", self, "_on_player_list_changed")
	$HUD/PlayerList/LocalPlayer.text = Gamestate.player_info.name


func game_over():
	$ScoreCounter.stop()
	$TimeCounter.stop()
	$MobTimer.stop()
	$PowerupTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	save_score(score)


func new_game():
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	score = 0
	time = 10
	highScores = load_scores()
	resetPlayer()
	$StartTimer.start()
	get_tree().call_group("hellspawn", "start")
	$HUD.update_score(score)
	$HUD.update_time(time)
	$HUD.show_high_scores(highScores)
	$HUD.show_message("Get Ready, " + $HUD/PlayerList/LocalPlayer.text + "!")
	$Music.play()
	

func new_round():
	time = 10
	$HUD.show_message("Next Round")
	$Player.scale_player("up")
	$HUD.update_time(time)
	_zoom("out")


func save_score(score):
	if $HUD/PlayerList/LocalPlayer.text != "":
		var file = File.new()
#		var file = $HTTPRequest.request("localhost:7777/scores.json")
		if score > get_player_high_score($HUD/PlayerList/LocalPlayer.text):
			file.open("./scores.json", File.WRITE)
			highScores[$HUD/PlayerList/LocalPlayer.text] = score
			file.store_string(JSON.print(highScores))
			file.close()


func load_scores():
	var file
	var request = $HTTPRequest.request("localhost:7777/scores.json")
	if request == OK:
		var json_records = JSON.parse(request.get_as_text())
		return json_records.result
	else:
		file = File.new()
		if file.file_exists("./scores.json"):
			file.open("./scores.json", File.READ)
			var json_records = JSON.parse(file.get_as_text())
			file.close()
			return json_records.result


func get_player_high_score(name):
	return highScores[name] if highScores.has(name) else 0


func _on_MobTimer_timeout():	
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()
	var mobType = mob.get_mob_props(mob, mob_spawn_location)
	mob.setup(mobType)
	add_child(mob)
	mob.add_to_group("enemies")

func _on_PowerupTimer_timeout():	
	# Choose a random location on Path2D.
	var powerup_spawn_location = get_node("PowerupPath/PowerupSpawnLocation")
	powerup_spawn_location.offset = randi()
	
	# Create a Powerup instance and add it to the scene.
	var powerup = powerup_scene.instance()
	var powerupType = powerup.get_powerup_props(powerup, powerup_spawn_location)
	powerup.setup(powerupType)
	add_child(powerup)
	powerup.add_to_group("powerups")

func _on_TimeCounter_timeout():
	time -= 1
	$HUD.update_time(time)
	if time == 0:
		new_round()

func _on_ScoreCounter_timeout():
	score += 1
	$HUD.update_score(score)
	if score == 2:
		$HUD.show_hint("Collect fruit for more points")

func _on_Player_bonus_points():
	score += 5
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$PowerupTimer.start()
	$ScoreCounter.start()
	$TimeCounter.start()

func _zoom(direction):
	var scaler
	if direction == "out":
		scaler = 0.25
	if direction == "in":
		scaler = -0.25

	$Player/Camera2D.zoom.x += scaler
	$Player/Camera2D.zoom.y += scaler

func resetCamera():
	$Player/Camera2D.zoom.x = 1
	$Player/Camera2D.zoom.y = 1

func resetPlayer():
	$Player.start($StartPosition.position)
	resetCamera()
	$Player.reset_scale_player()

func _on_player_list_changed():
	for c in $HUD/PlayerList/BoxList.get_children():
		c.queue_free()
	
	for p in Network.players:
		if (p != Gamestate.player_info.net_id):
			var nlabel = Label.new()
			nlabel.text = Network.players[p].name
			$HUD/PlayerList/BoxList.add_child(nlabel)

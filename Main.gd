extends Node

export(PackedScene) var mob_scene

var score
var highScores

func _ready():
	randomize()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	save_score(score)


func new_game():
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	score = 0
	highScores = load_scores()
	resetPlayer()
	$StartTimer.start()
	$HellSpawn.start()
	$HellSpawn2.start()
	$HellSpawn3.start()
	$HUD.update_score(score)
	$HUD.show_high_scores(highScores)
	$HUD.show_message("Get Ready")
	$Music.play()
	

func new_round():
	$HUD.show_message("Next Round")
	$Player.scale_player("up")
	_zoom("out")


func save_score(score):
	var file = File.new()
	if score > get_player_high_score($Player/Label.text):
		file.open("scores.json", File.WRITE)
		highScores[$Player/Label.text] = score
		file.store_string(JSON.print(highScores))

	file.close()


func load_scores():
	var file = File.new()
	if file.file_exists("scores.json"):
		file.open("scores.json", File.READ)
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

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	if score % 10 == 0:
		new_round()


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

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

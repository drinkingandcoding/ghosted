extends Node

export(PackedScene) var mob_scene
var score

func _ready():
	randomize()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HellSpawn.start()
	$HellSpawn2.start()
	$HellSpawn3.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()


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
	score += 10
	$HUD.update_score(score)
	if score % 100 == 0:
		print("growin")


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

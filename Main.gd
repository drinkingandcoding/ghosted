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
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()


func get_mob_props(mobInstance, spawn):
	
	var id = randi() % 3 + 1
	var name
	var speed

	if(id == 1):
		name = "enemySlow"
		speed = 100
	if(id == 2):
		name = "enemyMedium"
		speed = 300
	if(id == 3):
		name = "enemyFast"
		speed = 500

	# Set the mob's direction perpendicular to the path direction.
	var direction = spawn.rotation + PI / 2

	# Set the mob's position to a random location.
	mobInstance.position = spawn.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mobInstance.rotation = direction

	# Choose the velocity.
	var velocity = Vector2(speed, 0)
	mobInstance.linear_velocity = velocity.rotated(direction)
	
	return {
		"name": name,
		"speed": speed,
		"direction": direction,
		"position": mobInstance.position,
		"rotation": mobInstance.rotation,
		"velocity": velocity,
		"linear_velocity": mobInstance.linear_velocity
	}

func _on_MobTimer_timeout():	
	
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()
	var mobType = get_mob_props(mob, mob_spawn_location)
	print(mobType)
	add_child(mob)
	$Mob.setup(mobType) # this needs to be initialized with add_child

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

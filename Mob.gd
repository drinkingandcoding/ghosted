extends RigidBody2D
	
func setup(mobType):
	$AnimatedSprite.playing = true
	$AnimatedSprite.animation = mobType.name

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_start_game():
	queue_free()

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

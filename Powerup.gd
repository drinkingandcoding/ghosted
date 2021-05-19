extends RigidBody2D
	
func setup(powerupType):
	$AnimatedSprite.playing = true
	$AnimatedSprite.animation = powerupType.name

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_start_game():
	queue_free()

func get_powerup_props(powerupInstance, spawn):
	
	var name = "cherry"
	var speed = 600

	# Set the mob's direction perpendicular to the path direction.
	var direction = spawn.rotation + PI / 2

	# Set the mob's position to a random location.
	powerupInstance.position = spawn.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)

	# Choose the velocity.
	var velocity = Vector2(speed, 0)
	powerupInstance.linear_velocity = velocity.rotated(direction)
	
	return {
		"name": name,
		"speed": speed,
		"direction": direction,
		"position": powerupInstance.position,
		"rotation": powerupInstance.rotation,
		"velocity": velocity,
		"linear_velocity": powerupInstance.linear_velocity
	}

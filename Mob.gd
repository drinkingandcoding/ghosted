extends RigidBody2D

func _ready():
	print("ready")
	
func setup(mobType):
	$AnimatedSprite.playing = true
	$AnimatedSprite.animation = mobType.name

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_start_game():
	queue_free()

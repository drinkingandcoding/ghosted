extends Node2D

export(PackedScene) var bullet_scene

export(float) var timerCount = 0.5
var disabled

func _ready():
	$Timer.set_wait_time(timerCount)
	$Timer.start()
	disabled = true
	hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(.05)
	
func spawn_bullets():
	# Create a Mob instance and add it to the scene.
	var b = bullet_scene.instance()
	# Create a Mob instance and add it to the scene.
	b.position = self.position
	b.rotation = self.rotation

	get_parent().add_child(b)
	b.add_to_group("enemies")
	
#	var slow = bullet_scene.instance()
#	# Create a Mob instance and add it to the scene.
#	slow.position = self.position
#	slow.rotation = self.rotation
#	slow.type = "slow"
#	get_parent().add_child(slow)

func _on_Timer_timeout():
	if !disabled:
		spawn_bullets()

func start():
	disabled = false
	show()

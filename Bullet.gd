extends Node2D

var direction = Vector2(1,0)
var velocity = 5
var topSpeed = 25

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += Vector2(1 ,0).rotated(self.rotation)

func setupBullet():
	if self.type == "fast":
		self.position += Vector2((1 + velocity),0).rotated(self.rotation).clamped(topSpeed)
	if self.type == "slow":
		self.position += Vector2(1 ,0).rotated(self.rotation)

extends RigidBody2D

var speed = 125
var topSpeed = 25

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2(speed, 0).rotated(self.rotation)
	self.linear_velocity = velocity.rotated(self.rotation)

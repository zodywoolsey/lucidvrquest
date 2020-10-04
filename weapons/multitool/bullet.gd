extends RigidBody


# Declare member variables here. Examples:
var t = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	t += delta
	if t > 20 || ( t > .1 && abs(linear_velocity.x) < 5 && abs(linear_velocity.y) < 5 && abs(linear_velocity.z) < 5):
		queue_free()

func _on_Area_body_entered(collidedbody):
	if collidedbody.is_in_group('character'):
		# print("bullet collided")
		collidedbody.health -= 5
		queue_free()
extends KinematicBody


onready var right = get_node('player/rightHand')
onready var left = get_node('player/leftHand')
onready var cam = get_node('player/ARVRCamera')
onready var playerbody = get_node('playerbody')
onready var groundcheck = get_node('groundcheck')
onready var playerorigin = get_node('player')

onready var rx
onready var ry
onready var lx
onready var ly

var speed = 2
var deadzone = 0.42

var h_acceleration = 6
var h_velocity = Vector3()
var direction = Vector3()
var movement = Vector3()
var gravityvec = Vector3()
var gravity = 20
var fullcontact = false

var rloc
var lloc
var hloc

# Called when the node enters the scene tree for the first time.
func _ready():
	print('player started')
	print( get_viewport().size )
	
	
	
func _process(delta):
	rloc = right.get_node("HandArea/CollisionShape/MeshInstance").global_transform
	lloc =  left.get_node( "HandArea/CollisionShape/MeshInstance").global_transform
	hloc = get_node("player/ARVRCamera").global_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rx = right.get_joystick_axis(0)
	ry = right.get_joystick_axis(1)
	lx =  left.get_joystick_axis(0)
	ly =  left.get_joystick_axis(1)

	var leftstickvector = Vector2(lx,ly)

	direction = Vector3()

	if groundcheck.is_colliding():
		fullcontact = true
	else:
		fullcontact = false

	if not is_on_floor():
		gravityvec += Vector3.DOWN * gravity * delta
	elif is_on_floor() and fullcontact:
		gravityvec = -get_floor_normal() * gravity
	else:
		gravityvec = -get_floor_normal()

	
	if abs(leftstickvector.x) < deadzone:
		leftstickvector.x = 0
	if abs(leftstickvector.y) < deadzone:
		leftstickvector.y = 0

	
	leftstickvector = leftstickvector.normalized() * ((leftstickvector.length() - deadzone) / (1 - deadzone))
	if leftstickvector.y > 0:
		direction -= cam.global_transform.basis.z
	elif leftstickvector.y < 0:
		direction += cam.global_transform.basis.z
	if leftstickvector.x > 0:
		direction += cam.global_transform.basis.x
	elif leftstickvector.x < 0:
		direction -= cam.global_transform.basis.x
		

	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravityvec.z
	movement.x = h_velocity.x + gravityvec.x
	movement.y = gravityvec.y

	move_and_slide(movement, Vector3.UP)
	
	playerbody.global_transform.origin.x = cam.global_transform.origin.x
	playerbody.global_transform.origin.z = cam.global_transform.origin.z


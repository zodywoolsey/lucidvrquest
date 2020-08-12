extends ARVROrigin


onready var right = get_node('rightHand')
onready var left = get_node('leftHand')
onready var cam = get_node('ARVRCamera')

onready var rx
onready var ry
onready var lx
onready var ly

onready var rigidplayer = findNode('rigidplayer')

# Called when the node enters the scene tree for the first time.
#func _ready():
#	rigidplayer = findNode('rigidplayer')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rx = right.get_joystick_axis(0)
	ry = right.get_joystick_axis(1)
	lx = left.get_joystick_axis(0)
	ly = left.get_joystick_axis(1)

	if rx > .15 || rx < -.15:
		# print("rx" + str(rx))
		pass
	if ry > .15 || ry < -.15:
		# print("ry" + str(ry))
		pass
	if lx > .15 || lx < -.15:
		# print("lx" + str(lx))
		translate( Vector3(lx/1.0,0,0))
		pass
	if ly > .15 || ly < -.15:
		# print("ly" + str(ly))
		translate( Vector3(0,0,-(ly/1.0)))
#		rigidplayer = get_node('.')

func findNode(nodeName):
	return get_node('/root').find_node(nodeName, true, false)

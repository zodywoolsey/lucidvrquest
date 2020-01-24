extends ARVRController

var handGrab
var handArea
var handBody
var handRay
var grabShader

var grabDown = false
var triggerDown = false

var rayOn = false

var rayCollidedNode
var rayCollidedNodeMesh = null
var rayCollidedNodeOrigin
var handOrigin
var towardVector
var forceScaleFactor
var forceStrength = 50

var gravtmp = null
var damptmp = null
var rayCollidedtmp = null
var tmpMat = null
var pullInterval = 0

var body
var isCollided
var collides
var grabbed = false
var isGrabbable
var grabbedObject = null
var grabbedObjectOrigin

# var velStartTransformOrigin
# var velEndTransformOrigin
# var vel


# Called when the node enters the scene tree for the first time.
func _ready():
	handGrab = findNode('rightHandGrab')
	handArea = findNode('rightHandArea')
	handBody = findNode('rightHandBody')
	handRay = findNode('rightHandRay')
	grabShader = findNode('grabShaderMesh').get_material_override()


func _physics_process(delta):
	if grabDown:
		grabRigidGrabbable()
	if triggerDown && grabDown && !grabbed:
		grabRigidGrabbable()
		pullRigidGrabbable()
	if grabbedObject && grabbed:
		grabbedObjectOrigin = grabbedObject.global_transform.origin
		if ( sqrt( pow(grabbedObjectOrigin.x-global_transform.origin.x,2)+pow(grabbedObjectOrigin.y-global_transform.origin.y,2)+pow(grabbedObjectOrigin.z-global_transform.origin.z,2) ) > .2 ):
			handGrab.set_node_b('')
			grabbedObject = null
	if grabbedObject && !grabbed:
		handGrab.set_node_b("")
		grabbedObject = null
	if triggerDown:
		applyGrabShader()
			
func _on_rightHand_button_pressed(button):
	if button == 2:
		grabDown = true;
	if button == 15 && !grabbed:
		triggerDown = true
		rayOn = true
		handRay.set_enabled(true)
		handRay.show()

func _on_rightHand_button_release(button):
	if button == 2:
		grabDown = false
		if grabbed:
			grabbed = false
		if rayCollidedNode:
			rayCollidedNode.set_gravity_scale(gravtmp)
			rayCollidedNode.set_linear_damp(damptmp)
			rayCollidedtmp = null
			rayCollidedNode = null
			gravtmp = null
			damptmp = null
	if button == 15:
		triggerDown = false
		rayOn = false
		handRay.set_enabled(false)
		handRay.hide()
		if rayCollidedNode:
			rayCollidedNode.set_gravity_scale(gravtmp)
			rayCollidedNode.set_linear_damp(damptmp)
			rayCollidedtmp = null
			rayCollidedNode = null
			gravtmp = null
			damptmp = null
		if rayCollidedNodeMesh:
			rayCollidedNodeMesh.set_surface_material(0, tmpMat)
			rayCollidedNodeMesh = null
			tmpMat = null


func _on_rightHandArea_body_entered(body):
	isCollided = true

func _on_rightHandArea_body_exited(body):
	isCollided = false

func grabRigidGrabbable():
	if isCollided && !grabbed:
		collides = handArea.get_overlapping_bodies()
		for col in collides:
			isGrabbable = false
			isGrabbable = checkNodeGroups(col, 'grabbable')
			if col.get_class() == "RigidBody" && isGrabbable:
				grabbedObject = col
				grabbedObject.global_transform = handBody.global_transform
				handGrab.set_node_b(col.get_path())
				grabbed = true
				if handRay.is_enabled() == true:
					handRay.set_enabled(false)
					handRay.hide()
					if rayCollidedtmp:
						rayCollidedtmp.set_gravity_scale(gravtmp)
						rayCollidedtmp.set_linear_damp(damptmp)
						rayCollidedtmp = null
						rayCollidedNode = null
						damptmp = null
						gravtmp = null
					if rayCollidedNodeMesh:
						rayCollidedNodeMesh.set_surface_material(0, tmpMat)
						rayCollidedNodeMesh = null
						tmpMat = null
					rayOn = false
				break

func pullRigidGrabbable():
	if handRay.is_colliding() && !rayCollidedNode && handRay.get_collider().get_class() == "RigidBody" && checkNodeGroups(handRay.get_collider(), 'grabbable'):
		rayCollidedNode = get_node(handRay.get_collider().get_path())
		rayCollidedNodeMesh = rayCollidedNode.find_node('MeshInstance',true,true)
		if rayCollidedNodeMesh:
			if rayCollidedNodeMesh.get_surface_material(0) == null:
				rayCollidedNodeMesh.set_surface_material(0, grabShader)
			elif rayCollidedNodeMesh.get_surface_material(0).get_class() == "SpatialMaterial":
				tmpMat = rayCollidedNodeMesh.get_surface_material(0)
				rayCollidedNodeMesh.get_surface_material(0).flags_no_depth_test = true
		pullInterval = 0
	if grabDown && rayCollidedNode:
		if pullInterval < 72:
			pullInterval = pullInterval+1
		else:
			pullInterval = 0
			rayCollidedNode.global_transform = global_transform
		if !rayCollidedtmp || !gravtmp || !damptmp:
			rayCollidedtmp = rayCollidedNode
			gravtmp = rayCollidedtmp.get_gravity_scale()
			damptmp = rayCollidedtmp.get_linear_damp()
		if rayCollidedNode != rayCollidedtmp:
			rayCollidedtmp.set_gravity_scale(gravtmp)
			rayCollidedtmp = rayCollidedNode
			gravtmp = rayCollidedtmp.get_gravity_scale()
			damptmp = rayCollidedtmp.get_linear_damp()
		forceStrength = rayCollidedNode.get_mass()*50
		rayCollidedNode.set_gravity_scale(0)
		rayCollidedNodeOrigin = rayCollidedNode.get_global_transform().origin
		handOrigin = get_global_transform().origin
		towardVector = handOrigin-rayCollidedNodeOrigin
		if abs(towardVector[0]) > abs(towardVector[1]) && abs(towardVector[0]) > abs(towardVector[2]):
			forceScaleFactor = abs(forceStrength/towardVector[0])
		elif abs(towardVector[1]) > abs(towardVector[0]) && abs(towardVector[1]) > abs(towardVector[2]):
			forceScaleFactor = abs(forceStrength/towardVector[1])
		elif abs(towardVector[2]) > abs(towardVector[1]) && abs(towardVector[2]) > abs(towardVector[0]):
			forceScaleFactor = abs(forceStrength/towardVector[2])
		towardVector = towardVector*forceScaleFactor
		rayCollidedNode.add_force( towardVector, Vector3(0,0,0))


func findNode(nodeName):
	return get_node('/root').find_node(nodeName, true, false)

func checkNodeGroups(node, groupName):
	for group in node.get_groups():
		if group == groupName:
			return true
	return false
func checkNodeNameGroups(nodeName, groupName):
	for group in findNode(nodeName).get_groups():
		if group == groupName:
			return true
	return false


func applyGrabShader():
	if rayCollidedNodeMesh && handRay.is_colliding():
		if rayCollidedNodeMesh != get_node(handRay.get_collider().get_path()).find_node('MeshInstance',true,true):
			rayCollidedNodeMesh.set_surface_material(0, null)
			rayCollidedNodeMesh = null
			tmpMat = null
	elif rayCollidedNodeMesh && handRay.is_colliding() == false:
		rayCollidedNodeMesh.set_surface_material(0, null)
		rayCollidedNodeMesh = null
		tmpMat = null
	if handRay.is_colliding() && !rayCollidedNode && handRay.get_collider().get_class() == "RigidBody" && checkNodeGroups(handRay.get_collider(), 'grabbable'):
		rayCollidedNodeMesh = get_node(handRay.get_collider().get_path()).find_node('MeshInstance',true,true)
		if rayCollidedNodeMesh:
			if rayCollidedNodeMesh.get_surface_material(0) == null:
				rayCollidedNodeMesh.set_surface_material(0, grabShader)
			elif rayCollidedNodeMesh.get_surface_material(0).get_class() == "SpatialMaterial":
				tmpMat = rayCollidedNodeMesh.get_surface_material(0)
				rayCollidedNodeMesh.get_surface_material(0).flags_no_depth_test = true


#		pullBackup:
#if handRay.is_colliding() && grabDown:
# if handRay.get_collider().get_class() == "RigidBody":
# 	rayCollidedNode = get_node(handRay.get_collider().get_path())
# 	if !rayCollidedtmp || !gravtmp:
# 		rayCollidedtmp = rayCollidedNode
# 		gravtmp = rayCollidedtmp.get_gravity_scale()
# 	if rayCollidedNode != rayCollidedtmp:
# 		rayCollidedtmp.set_gravity_scale(gravtmp)
# 		rayCollidedtmp = rayCollidedNode
# 		gravtmp = rayCollidedtmp.get_gravity_scale()
# 	if checkNodeGroups(rayCollidedNode,'grabbable'):
# 		forceStrength = rayCollidedNode.get_mass()*50
# 		rayCollidedNode.set_gravity_scale(0)
# 		rayCollidedNodeOrigin = rayCollidedNode.get_global_transform().origin
# 		handOrigin = get_global_transform().origin
# 		towardVector = handOrigin-rayCollidedNodeOrigin
# 		if abs(towardVector[0]) > abs(towardVector[1]) && abs(towardVector[0]) > abs(towardVector[2]):
# 			forceScaleFactor = abs(forceStrength/towardVector[0])
# 		elif abs(towardVector[1]) > abs(towardVector[0]) && abs(towardVector[1]) > abs(towardVector[2]):
# 			forceScaleFactor = abs(forceStrength/towardVector[1])
# 		elif abs(towardVector[2]) > abs(towardVector[1]) && abs(towardVector[2]) > abs(towardVector[0]):
# 			forceScaleFactor = abs(forceStrength/towardVector[2])
# 		towardVector = towardVector*forceScaleFactor
# 		rayCollidedNode.add_force( towardVector, Vector3(0,0,0))

extends Spatial

# onready var ovr_init_config = preload("res://addons/godot_ovrmobile/OvrInitConfig.gdns").new()
# onready var ovr_performance = preload("res://addons/godot_ovrmobile/OvrPerformance.gdns").new()
var ovr_init_config
var ovr_performance

var perform_runtime_config = false
var arServ = ''

var settingsFile
var interface = null

func _ready():
	interface = ARVRServer.find_interface('OpenVR')
	Engine.iterations_per_second = 80
	if interface:
		if interface.initialize():
			get_viewport().arvr = true
			OS.vsync_enabled = false

# func _process(_delta):
# 	if !perform_runtime_config:
# 		ovr_performance.set_clock_levels(1, 1)
# 		ovr_performance.set_extra_latency_mode(1)
# 		perform_runtime_config = true

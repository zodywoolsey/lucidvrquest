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
	settingsFile = File.new()
	if not settingsFile.file_exists('res://settings.txt'):
		settingsFile.open('res://settings.txt', File.WRITE)
	if settingsFile.open("res://settings.txt",File.READ) != 0:
		print('Error, will crash')
	var settingsData = {}
	settingsData = settingsFile.get_line()
	print(settingsData)
	if settingsData == 'ovr':
		interface = ARVRServer.find_interface('OpenVR')
		arServ = 'ovr'
		Engine.iterations_per_second = 90
	elif settingsData == 'oculus':
		interface = ARVRServer.find_interface('Oculus')
		arServ = 'oculus'
		Engine.iterations_per_second = 80
	elif settingsData == 'quest':
		interface = ARVRServer.find_interface("OVRMobile")
		arServ = 'ovrMobile'
	if interface:
		if arServ == 'ovrMobile':
			ovr_init_config = preload('res://addons/godot_ovrmobile/OvrInitConfig.gdns').new()
			ovr_performance = preload('res://addons/godot_ovrmobile/OvrPerformance.gdns').new()
			ovr_init_config.set_render_target_size_multiplier(1)
			ovr_performance.set_clock_levels(1, 1)
			ovr_performance.set_extra_latency_mode(1)
			Engine.iterations_per_second = 72
			
		if interface.initialize():
			get_viewport().arvr = true
			OS.vsync_enabled = false
			if arServ == 'ovr':
				get_viewport().keep_3d_linear = true

# func _process(_delta):
# 	if !perform_runtime_config:
# 		ovr_performance.set_clock_levels(1, 1)
# 		ovr_performance.set_extra_latency_mode(1)
# 		perform_runtime_config = true

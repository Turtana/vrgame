extends Spatial

var use_vr = true

func _ready():
	if use_vr:
		var VR = ARVRServer.find_interface("OpenVR")
		if VR and VR.initialize():
			get_viewport().arvr = true
			get_viewport().hdr = false
			OS.vsync_enabled = false
			Engine.target_fps = 90

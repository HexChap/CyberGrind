extends XROrigin3D

var _left_controller : XRController3D
var _right_controller : XRController3D

func _ready() -> void:
	_left_controller = XRTools.find_xr_child(self, "LeftHand", "XRController3D")
	_right_controller = XRTools.find_xr_child(self, "RightHand", "XRController3D")
	
	_left_controller.trigger_haptic_pulse("haptic", 0.0, 0.8, 120, 0.0)
	_right_controller.trigger_haptic_pulse("godot/haptic", 0.0, 0.8, 120, 0.0)

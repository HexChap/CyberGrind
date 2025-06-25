extends XRController3D

signal hand_grabbed(controller: XRController3D)
signal hand_released(controller: XRController3D)

func _ready():
	button_pressed.connect(_on_button_pressed)
	input_float_changed.connect(_on_input_float_changed)

func _on_button_pressed(name):
	if name == "grip_click":
		emit_signal("hand_grabbed", self)

func _on_input_float_changed(name, value):
	if name == "grip_click":
		if value > 0.1:
			emit_signal("hand_grabbed", self)
		else:
			emit_signal("hand_released", self)

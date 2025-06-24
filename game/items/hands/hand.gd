extends XRController3D

signal hand_grabbed
signal hand_released

func _ready():
	button_pressed.connect(_on_button_pressed)
	input_float_changed.connect(_on_input_float_changed)

func _on_button_pressed(name):
	if name == "grip_click":
		emit_signal("hand_grabbed")

func _on_input_float_changed(name, value):
	if name == "grip_click":
		if value > 0.1:
			emit_signal("hand_grabbed")
		else:
			emit_signal("hand_released")

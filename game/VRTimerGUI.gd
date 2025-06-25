# VRTimerGUI.gd
# Attach this script to a Label node that will serve as the timer display

extends Label

var current_time: float = 0.0
var is_running: bool = false
var xr_camera: XRCamera3D
var update_interval: float = 0.1  # Update 10 times per second for smooth display

# Style properties
var normal_color: Color = Color(0.9, 0.9, 1.0, 0.95)  # Light blue-white
var warning_color: Color = Color(1.0, 0.8, 0.2, 0.95)  # Orange
var critical_color: Color = Color(1.0, 0.3, 0.3, 0.95)  # Red
var finished_color: Color = Color(0.3, 1.0, 0.3, 0.95)  # Green

func _ready():
	# Find the XR camera in the scene
	xr_camera = get_viewport().get_camera_3d()
	if not xr_camera:
		# Fallback: search for XRCamera3D node
		xr_camera = get_tree().get_first_node_in_group("xr_camera")
	
	# Set up the label styling
	setup_label_style()
	update_display()

func setup_label_style():
	# Position the label at top center
	anchor_left = 0.5
	anchor_right = 0.5
	anchor_top = 0.0
	anchor_bottom = 0.0
	offset_left = -120  # Half of desired width
	offset_right = 120   # Half of desired width
	offset_top = 40
	offset_bottom = 90
	
	# Text alignment
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Create and apply custom font
	var font_file = SystemFont.new()
	font_file.font_names = ["Arial", "Helvetica", "Sans-Serif"]
	font_file.font_weight = 700  # Bold
	add_theme_font_override("font", font_file)
	add_theme_font_size_override("font_size", 28)
	
	# Text styling
	modulate = normal_color
	
	# Create background using StyleBox
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.1, 0.1, 0.2, 0.85)  # Dark blue-gray with transparency
	style_box.corner_radius_top_left = 15
	style_box.corner_radius_top_right = 15
	style_box.corner_radius_bottom_left = 15
	style_box.corner_radius_bottom_right = 15
	
	# Add border
	style_box.border_color = Color(0.4, 0.6, 1.0, 0.8)  # Light blue border
	style_box.border_width_top = 2
	style_box.border_width_bottom = 2
	style_box.border_width_left = 2
	style_box.border_width_right = 2
	
	# Add shadow effect
	style_box.shadow_color = Color(0, 0, 0, 0.6)
	style_box.shadow_size = 8
	style_box.shadow_offset = Vector2(2, 2)
	
	# Apply background style
	add_theme_stylebox_override("normal", style_box)
	
	# Add subtle glow effect using outline
	add_theme_color_override("font_outline_color", Color(0.4, 0.6, 1.0, 0.3))
	add_theme_constant_override("outline_size", 4)

func _process(delta):
	# Update timer if running
	if is_running and current_time > 0:
		current_time -= delta
		if current_time <= 0:
			current_time = 0.0
			is_running = false
			_on_timer_finished()
		update_display()
	
	# Keep the UI positioned for VR

func add_floating_animation():
	# Subtle floating animation for VR immersion
	var time = Time.get_time_dict_from_system()
	var float_offset = sin(Time.get_time_dict_from_system().second * 2.0 + Time.get_time_dict_from_system().nanosecond / 1000000000.0) * 2.0
	offset_top = 40 + float_offset

func start_timer(duration: float):
	"""Start the timer with a specific duration in seconds"""
	current_time = duration
	is_running = true
	update_display()
	add_start_effect()
	print("Timer started for ", format_time(duration))

func stop_timer():
	"""Stop the timer"""
	is_running = false
	add_stop_effect()
	print("Timer stopped")

func pause_timer():
	"""Pause the timer"""
	is_running = false
	add_pause_effect()
	print("Timer paused")

func resume_timer():
	"""Resume the timer"""
	if current_time > 0:
		is_running = true
		add_resume_effect()
		print("Timer resumed")

func reset_timer():
	"""Reset the timer to 0"""
	current_time = 0.0
	is_running = false
	update_display()
	add_reset_effect()
	print("Timer reset")

func add_time(seconds: float):
	"""Add time to the current timer"""
	current_time += seconds
	update_display()
	add_time_added_effect()
	print("Added ", seconds, " seconds to timer")

func _on_timer_finished():
	"""Called when timer reaches zero"""
	print("Timer finished!")
	update_display()
	add_completion_effect()

func update_display():
	"""Update the timer display with styling"""
	var display_text = format_time(current_time)
	
	# Add status indicator
	if not is_running and current_time > 0:
		display_text += " ⏸"  # Pause symbol
	elif is_running:
		display_text += " ▶"  # Play symbol
	elif current_time <= 0:
		display_text = "00:00 ✓"  # Checkmark when finished
	
	text = display_text
	
	# Update color based on time remaining
	if current_time <= 0:
		modulate = finished_color
	elif current_time <= 10:
		modulate = critical_color
		add_pulse_effect()
	elif current_time <= 30:
		modulate = warning_color
	else:
		modulate = normal_color

func format_time(seconds: float) -> String:
	"""Format time as MM:SS or HH:MM:SS if over an hour"""
	var total_seconds = int(seconds)
	var hours = total_seconds / 3600
	var minutes = (total_seconds % 3600) / 60
	var secs = total_seconds % 60
	
	if hours > 0:
		return "%02d:%02d:%02d" % [hours, minutes, secs]
	else:
		return "%02d:%02d" % [minutes, secs]

func add_pulse_effect():
	"""Add pulsing effect for critical time"""
	var tween = create_tween()
	tween.set_loops(2)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)

func add_start_effect():
	"""Visual effect when timer starts"""
	var tween = create_tween()
	scale = Vector2(0.8, 0.8)
	modulate.a = 0.5
	tween.parallel().tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)
	tween.parallel().tween_property(self, "modulate:a", 0.95, 0.3)

func add_stop_effect():
	"""Visual effect when timer stops"""
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.6, 0.2)
	tween.tween_property(self, "modulate:a", 0.95, 0.2)

func add_pause_effect():
	"""Visual effect when timer pauses"""
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

func add_resume_effect():
	"""Visual effect when timer resumes"""
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

func add_reset_effect():
	"""Visual effect when timer resets"""
	var tween = create_tween()
	tween.tween_property(self, "rotation", deg_to_rad(-10), 0.1)
	tween.tween_property(self, "rotation", deg_to_rad(10), 0.1)
	tween.tween_property(self, "rotation", 0, 0.1)

func add_time_added_effect():
	"""Visual effect when time is added"""
	var tween = create_tween()
	var original_color = modulate
	tween.tween_property(self, "modulate", Color.CYAN, 0.2)
	tween.tween_property(self, "modulate", original_color, 0.3)

func add_completion_effect():
	"""Visual effect when timer completes"""
	var tween = create_tween()
	tween.set_loops(3)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.3)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)

# Convenience functions
func get_time_remaining() -> float:
	"""Get the remaining time in seconds"""
	return current_time

func is_timer_running() -> bool:
	"""Check if timer is currently running"""
	return is_running

func start_countdown_timer(minutes: int, seconds: int = 0):
	"""Convenience function to start timer with minutes and seconds"""
	var total_seconds = minutes * 60 + seconds
	start_timer(float(total_seconds))

func start_quick_timer(seconds: int):
	"""Quick function to start a timer with just seconds"""
	start_timer(float(seconds))

func get_formatted_time() -> String:
	"""Get the current time as a formatted string"""
	return format_time(current_time)

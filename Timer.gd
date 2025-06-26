extends CanvasLayer

# Timer variables
var time_remaining: float = 0.0
var timer_running: bool = false
var timer_label: Label

# Reference to the player's camera
onready var player_camera = get_node("/root/YourMainScene/Player/Camera")

func _ready():
	timer_label = $Label
	timer_label.text = "Time: 0:00"
	start_timer(30.0)  # Start timer with an initial value of 30 seconds for testing

# Update function to display and update timer
func _process(delta):
	if timer_running:
		# Update the timer countdown
		time_remaining -= delta
		if time_remaining <= 0:
			time_remaining = 0
			timer_running = false
		# Update the label text
		timer_label.text = format_time(time_remaining)

	# Position the timer in the top-middle of the screen
	update_timer_position()

# Format time as mm:ss
func format_time(seconds: float) -> String:
	var minutes = int(seconds / 60)
	var seconds = int(seconds % 60)
	return "{:02}:{:02}".format(minutes, seconds)

# Function to adjust the timer dynamically
func start_timer(new_time: float):
	time_remaining = new_time
	timer_running = true

# Keep the timer UI at the top middle of the screen
func update_timer_position():
	var screen_size = get_viewport().size
	var screen_center = screen_size / 2
	var offset = Vector2(0, -screen_size.y * 0.4)  # 40% from the top

	# Convert world position of the camera to screen space
	var camera_position = player_camera.project_position(Vector3(0, 0, 0))
	
	# Set the timer position to the calculated position
	timer_label.rect_position = screen_center + offset

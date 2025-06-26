extends Node3D

@onready var area := $Area3D
@export var tilt_strength := 0.4 
@export var max_tilt_angle_deg := 60.0  # Max angle to tilt toward camera
var camera: Camera3D
var rest_forward := Vector3.ZERO

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	camera = get_viewport().get_camera_3d()
	rest_forward = (-global_transform.basis.z).normalized()

func _on_body_entered(body):
	if body is XRToolsCollisionHand:
		print("Back entered")
		body.get_parent().hand_grabbed.connect(_on_controller_grabbed)

func _on_body_exited(body):
	if body is XRToolsCollisionHand:
		print("Back exited")
		body.get_parent().hand_grabbed.disconnect(_on_controller_grabbed)

func _on_controller_grabbed(_xr_controller):
	print("rollbacked :3")
	var sudoku_node = get_tree().get_nodes_in_group("SudokuRoot")[0]
	sudoku_node.backtrack()


func _process(delta):
	camera = get_viewport().get_camera_3d()
	if not is_instance_valid(camera):
		camera = get_viewport().get_camera_3d()
		if not is_instance_valid(camera):
			return
	
	# 1) Get direction toward camera (flip so +Z faces it):
	var to_camera = (camera.global_transform.origin - global_transform.origin).normalized() * -1.0

	# 2) Compute the full angle between rest_forward and to_camera:
	var dot = clamp(rest_forward.dot(to_camera), -1.0, 1.0)
	var full_angle = acos(dot)  # radians

	# 3) Compute how far we actually want to tilt (in radians):
	var max_rad = deg_to_rad(max_tilt_angle_deg)
	# the “blend factor” so that rest_forward.slerp → at most max_rad:
	var blend_t = tilt_strength
	if full_angle * tilt_strength > max_rad and full_angle > 0.001:
		blend_t = max_rad / full_angle

	# 4) Interpolate from the _rest_ forward toward camera up to that cap:
	var blended_forward = rest_forward.slerp(to_camera, blend_t).normalized()

	# 5) Finally, look at the point ahead on that blended vector:
	var target = global_transform.origin + blended_forward
	look_at(target, Vector3.UP)

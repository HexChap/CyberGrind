extends Node3D

func _ready():
	# Create the mesh
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)

	# Triangle vertices
	var verts = PackedVector3Array([
		Vector3(0, 1, 0),
		Vector3(1, 0, 0),
		Vector3(0, 0, 1),
	])
	arrays[Mesh.ARRAY_VERTEX] = verts

	# Compute and assign normals
	var face_normal = (verts[1] - verts[0]).cross(verts[2] - verts[0]).normalized()
	arrays[Mesh.ARRAY_NORMAL] = PackedVector3Array([face_normal, face_normal, face_normal])

	# Build the surface
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	# Give it a simple red material
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1, 0, 0)
	arr_mesh.surface_set_material(0, mat)

	# Instance it and move it in front of the camera
	var mi = MeshInstance3D.new()
	mi.mesh = arr_mesh
	add_child(mi)

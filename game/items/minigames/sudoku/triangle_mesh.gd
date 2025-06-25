@tool
extends MeshInstance3D

func _ready():
	var mesh = ArrayMesh.new()

	var vertices = PackedVector3Array()
	vertices.append(Vector3(0, 1, 0))   # Top
	vertices.append(Vector3(-1, -1, 0)) # Bottom left
	vertices.append(Vector3(1, -1, 0))  # Bottom right

	var indices = PackedInt32Array([0, 1, 2])

	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices

	mesh.clear_surfaces()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	self.mesh = mesh

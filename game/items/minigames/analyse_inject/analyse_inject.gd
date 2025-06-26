extends Node3D

var specialized_vuln_scn = preload("res://game/items/minigames/analyse_inject/vulnerability_inject/vulnerability_node.tscn")

var spec_vuln_node: Node3D

func _ready() -> void:
	$AnalysisArea.vuln_selected.connect(_on_vuln_selected)

func _on_vuln_selected(vuln_node: Node3D):
	var parent = vuln_node.get_parent()
	var transform = vuln_node.transform

	parent.remove_child(vuln_node)
	vuln_node.queue_free()

	spec_vuln_node = specialized_vuln_scn.instantiate()
	spec_vuln_node.name = vuln_node.name  # preserve name
	spec_vuln_node.transform = transform  # apply old position/rotation/scale

	parent.add_child(spec_vuln_node)

extends Node

@export_file('*.tscn') var zone_scene : String = "res://objects/cyber_space/cyber_space.tscn"
@export var spawn_node_name := "MainCyberSpaceEntry"

func play():
	print("PLAY PRESSSED")
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	if not scene_base:
		print("no base :<")
		return

	if zone_scene == "":
		print("reset or smt")
		scene_base.reset_scene(spawn_node_name)
	else:
		print("load or smt")
		scene_base.load_scene(zone_scene, spawn_node_name)

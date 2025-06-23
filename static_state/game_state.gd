# game_state.gd
extends Node

enum MainGameState {
	MAIN_MENU,
	PAUSED,
	PLAYING
}

@export_file('*.tscn') var MAIN_MENU_TSCN  : String = "res://main.tscn";
@export_file('*.tscn') var CYBERSPACE_TSCN  : String = "";
@export_file('*.tscn') var HACKING_TSCN  : String = "";

enum Scene {
	MAIN_MENU,
	CYBERSPACE,
	HACKING
}
var SceneNames = {
	Scene.MAIN_MENU: MAIN_MENU_TSCN,
	Scene.CYBERSPACE: CYBERSPACE_TSCN,
	Scene.HACKING: HACKING_TSCN
}

@export var GAMESTATE : MainGameState = MainGameState.MAIN_MENU
@export var CURRENTSCENE : Scene = Scene.MAIN_MENU

func _ready():
	GAMESTATE = MainGameState.MAIN_MENU
	CURRENTSCENE = Scene.MAIN_MENU
	
#static func switch_scene(scene_base: XRToolsSceneBase, scene: Scene, entry_point: String): 
	##var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	#
	#if not scene_base:
		#return
	#
	#if SceneNames[scene] == "":
		#scene_base.reset_scene(entry_point)
	#else:
		#scene_base.load_scene(SceneNames[scene], entry_point)

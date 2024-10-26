@tool
extends EditorPlugin

const FBX = preload("res://addons/godot_synty_asset_helper/scripts/fbx.gd")
const MESHES = preload("res://addons/godot_synty_asset_helper/scripts/meshes.gd")
const TEXTURES = preload("res://addons/godot_synty_asset_helper/scripts/textures.gd")
const MATERIALS = preload("res://addons/godot_synty_asset_helper/scripts/materials.gd")

const STATIC_MESHES_DIR = "res://addons/godot_synty_asset_helper/static_meshes/"
const SKELETONS_DIR = "res://addons/godot_synty_asset_helper/skeletons/"
	

func _enable_plugin() -> void:
	if not DirAccess.dir_exists_absolute("res://addons/godot_synty_asset_helper/Source_Files/"):
		push_error("No Source_Files folder found. You need to add the Synty source files to the addons folder manually before enabling the plugin.")
		return
	print_rich("[color=blue]GODOT SYNTY ASSET HELPER: starting asset import and generation...")
	MATERIALS.generate_from_source()
	MESHES.generate_from_source()
	print_rich("[color=blue]GODOT SYNTY ASSET HELPER: finished asset import and generation!")
	EditorInterface.restart_editor()


func _enter_tree() -> void:
	pass

func _exit_tree():
	pass
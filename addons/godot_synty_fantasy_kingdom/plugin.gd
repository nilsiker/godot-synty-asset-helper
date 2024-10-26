@tool
extends EditorPlugin

const FBX = preload("res://addons/godot_synty_fantasy_kingdom/scripts/fbx.gd")
const MESHES = preload("res://addons/godot_synty_fantasy_kingdom/scripts/meshes.gd")
const TEXTURES = preload("res://addons/godot_synty_fantasy_kingdom/scripts/textures.gd")
const MATERIALS = preload("res://addons/godot_synty_fantasy_kingdom/scripts/materials.gd")

const STATIC_MESHES_DIR = "res://addons/godot_synty_fantasy_kingdom/static_meshes/"
const SKELETONS_DIR = "res://addons/godot_synty_fantasy_kingdom/skeletons/"
	

func _enable_plugin() -> void:
	if not DirAccess.dir_exists_absolute("res://addons/godot_synty_fantasy_kingdom/Source_Files/"):
		push_error("No Source_Files folder found. You need to add the Synty source files to the addons folder manually before enabling the plugin.")
		return

	print("STARTING SYNTY FANTASY KINGDOM SETUP")
	MATERIALS.generate_from_source()
	MESHES.generate_from_source()


func _enter_tree() -> void:
	pass

func _exit_tree():
	pass
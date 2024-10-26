const MATERIALS = preload("res://addons/godot_synty_asset_helper/scripts/materials.gd")

const SOURCE_DIR = "res://addons/godot_synty_asset_helper/Source_Files/FBX/"
const BONUS_SOURCE_DIR = "res://addons/godot_synty_asset_helper/Source_Files/BonusFBX/"
const SCENES_DIR = "res://addons/godot_synty_asset_helper/scenes/"

	
static func get_files() -> Array:
	var dir = DirAccess.open(SOURCE_DIR)
	var source_files = Array(dir.get_files()).filter(is_fbx).map(prefix_with_source_dir)
	
	var bonus_dir = DirAccess.open(BONUS_SOURCE_DIR)
	var bonus_source_files = Array(bonus_dir.get_files()).filter(is_fbx).map(prefix_with_bonus_source_dir)
	source_files.append_array(bonus_source_files)
	
	return source_files

static func is_fbx(file): return file.ends_with(".fbx")
static func prefix_with_source_dir(file): return SOURCE_DIR + file
static func prefix_with_bonus_source_dir(file): return BONUS_SOURCE_DIR + file
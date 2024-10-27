const MATERIALS = preload("res://addons/godot_synty_asset_helper/scripts/materials.gd")

const SCENES_DIR = "res://addons/godot_synty_asset_helper/scenes/"

	
static func get_file_paths(pack: Pack) -> Array:
	var files = []

	for source in pack.meshes.sources:
		var dir = DirAccess.open(source)
		var source_files = Array(dir.get_files()).filter(is_fbx).filter(has_mesh_prefix).map(func(file): return prefix_with_folder(source, file))
		files.append_array(source_files)

	return files

static func is_fbx(file) -> bool:
	return file.ends_with(".fbx")

static func has_mesh_prefix(file) -> bool:
	return file.begins_with("SM_")

static func prefix_with_folder(folder, file) -> String:
	return folder + file
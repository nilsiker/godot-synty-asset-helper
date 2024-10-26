const MATERIALS = preload("res://addons/godot_synty_asset_helper/scripts/materials.gd")
const FBX = preload("res://addons/godot_synty_asset_helper/scripts/fbx.gd")

const MESHES_PREFIX = "SM_"
const MESHES_DIR = "res://addons/godot_synty_asset_helper/meshes/"

const GENERIC_PREFIX = "Generic_"
const GENERIC_DIR = MESHES_DIR + "generic/"

const ENVIRONMENT_PREFIX = "Env_"
const ENVIRONMENT_DIR = MESHES_DIR + "environment/"

const ITEM_PREFIX = "Item_"
const ITEM_DIR = MESHES_DIR + "items/"

const WEAPON_PREFIX = "Wep_"
const WEAPON_DIR = MESHES_DIR + "weapon/"

const BUILDING_PREFIX = "Bld_"
const BUILDING_DIR = MESHES_DIR + "buildings/"

const PROP_PREFIX = "Prop_"
const PROP_DIR = MESHES_DIR + "props/"
	
static func generate_from_source():
	print("godot_synty_asset_helper: generating static meshes...")
	DirAccess.make_dir_absolute(MESHES_DIR)
	DirAccess.make_dir_absolute(ENVIRONMENT_DIR)
	DirAccess.make_dir_absolute(ITEM_DIR)
	DirAccess.make_dir_absolute(WEAPON_DIR)
	DirAccess.make_dir_absolute(BUILDING_DIR)
	DirAccess.make_dir_absolute(PROP_DIR)
	DirAccess.make_dir_absolute(GENERIC_DIR)

	var fbx_files = FBX.get_files()
	var mesh_files = fbx_files.filter(_is_static_mesh_file)

	var material_dict = MATERIALS.get_material_dict()

	for file: String in mesh_files:
		var filename = file.split(".")[0].trim_prefix("SM_")

		if filename.ends_with("Optimized"):
			push_warning("Skipping: Optimized FBXs not handled. ({1})".format([filename, file]))
			continue

		var fbx: PackedScene = load(FBX.SOURCE_DIR + file)

		if not fbx:
			push_warning("Failed to load {0}".format([file]))
		
		var node: Node = fbx.instantiate()
		node.name = filename

		var mesh_instances: Array[MeshInstance3D] = []
		_drill_for_mesh_instances(node, mesh_instances)

		for mesh_instance in mesh_instances:
			if material_dict.has(mesh_instance.name):
				var mesh_material_names = material_dict[mesh_instance.name]
				var material: StandardMaterial3D = load(MATERIALS.DIRECTORY + mesh_material_names[0] + ".res")
				mesh_instance.mesh.surface_set_material(0, material)

			var mesh_name = filename + ".res"
			var category_prefix = _get_category_prefix(filename)
			var category_dir = _get_category_dir(filename)
			var mesh_path = category_dir + mesh_name.trim_prefix(category_prefix)

			var res = ResourceSaver.save(mesh_instance.mesh, mesh_path)
			if not res == OK:
				push_error("Failed when saving scene {0} to {1}. Result: {2} ({3})".format([filename, mesh_path, res, file]))
		node.queue_free()


static func _drill_for_mesh_instances(node: Node, mesh_instances: Array[MeshInstance3D]):
	if node is MeshInstance3D:
		mesh_instances.push_back(node)
	for child in node.get_children():
		_drill_for_mesh_instances(child, mesh_instances)


static func _is_static_mesh_file(file):
	return file.begins_with(MESHES_PREFIX)

static func _get_category_prefix(filename: String) -> String:
	var prefix = filename.split("_")[0] + "_"
	if [ITEM_PREFIX, WEAPON_PREFIX, GENERIC_PREFIX, BUILDING_PREFIX, ENVIRONMENT_PREFIX, PROP_PREFIX].find(prefix) != -1:
		return prefix
	else:
		return ""

static func _get_category_dir(filename: String) -> String:
	match filename.split("_")[0] + "_":
		ITEM_PREFIX: return ITEM_DIR
		WEAPON_PREFIX: return WEAPON_DIR
		BUILDING_PREFIX: return BUILDING_DIR
		ENVIRONMENT_PREFIX: return ENVIRONMENT_DIR
		PROP_PREFIX: return PROP_DIR
		_: return GENERIC_DIR
const TEXTURES = preload("res://addons/godot_synty_asset_helper/scripts/textures.gd")

const MATERIAL_LIST_PATH = "res://addons/godot_synty_asset_helper/Source_Files/MaterialList_PolygonFantasyKingdom.txt"
const DIRECTORY = "res://addons/godot_synty_asset_helper/materials/"

static func generate_from_source():
	print("GODOT SYNTY ASSET HELPER: generating materials...")
	DirAccess.make_dir_absolute(DIRECTORY)

	var file = FileAccess.open(MATERIAL_LIST_PATH, FileAccess.ModeFlags.READ)
	var prefab_name
	var mesh_name

	var created_materials = []
	while file.get_position() < file.get_length():
		var line = file.get_line().strip_edges()
		if line.begins_with("Slot:"):
			var material_name = line.split(" ")[1]
			var material_path = DIRECTORY + material_name + ".res"
			var texture_name = line.split(" ")[-1]

			if created_materials.find(material_path) != -1: continue
			created_materials.push_back(material_path)
			
			if not texture_name.begins_with("("):
				push_warning("Setup script does not support custom shaders, or albedo texture is empty. ({0})".format([material_path]))
				continue

			texture_name = texture_name.erase(0)
			texture_name = texture_name.erase(texture_name.length() - 1)

			var material = StandardMaterial3D.new()
			material.albedo_texture = load(TEXTURES.SOURCE_DIRECTORY + texture_name + ".png")
			material.vertex_color_use_as_albedo = false
			var res = ResourceSaver.save(material, material_path)

			if not res == OK:
				push_error("\tFailed when creating material {0} to {1} (Result: {2})".format([material_name, material_path, res]))
	print_rich("[color=blue]GODOT SYNTY ASSET HELPER: successfully created materials")


static func get_material_dict() -> Dictionary:
	var dict: Dictionary = {}
	
	var file = FileAccess.open(MATERIAL_LIST_PATH, FileAccess.ModeFlags.READ)

	var mesh_name
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line.begins_with("Mesh Name"):
			mesh_name = line.split(" ")[-1]
			dict[mesh_name] = []
		elif line.begins_with("Slot:"):
			var material_name = line.split(" ")[1]
			dict[mesh_name].push_back(material_name)
	return dict

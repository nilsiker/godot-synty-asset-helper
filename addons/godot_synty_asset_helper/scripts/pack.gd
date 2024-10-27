class_name Pack

const MESHES = preload("res://addons/godot_synty_asset_helper/scripts/meshes.gd")
const MATERIALS = preload("res://addons/godot_synty_asset_helper/scripts/materials.gd")

var name: String
var source_files: String
var materials: Dictionary
var meshes: Dictionary

func _init(name: String) -> void:
	var config_path = "res://addons/godot_synty_asset_helper/{0}/config.json".format([name])
	var json = JSON.parse_string(FileAccess.get_file_as_string(config_path))
	
	self.name = name
	self.source_files = json.source_files
	self.materials = json.materials
	self.meshes = json.meshes

	assert_source_files()


func assert_source_files():
	assert(DirAccess.dir_exists_absolute(self.source_files))


func import():
	print_rich("[b]GODOT SYNTY ASSET HELPER ({0}):[/b] starting import...".format([self.name]))

	if materials:
		DirAccess.make_dir_recursive_absolute(materials.target_folder)
		var imported_mats = MATERIALS.from_pack(self)
		for material in imported_mats:
			var path = materials.target_folder + material.resource_name + ".res"
			if ResourceSaver.save(material, path) != OK:
				push_error("failed to save material {0} to {1}".format([material.resource_name, path]))
	
	if meshes:
		for folder in meshes.target_folders: DirAccess.make_dir_recursive_absolute(folder)
		var imported_meshes = MESHES.from_pack(self)

		for mesh in imported_meshes:
			var folder = meshes.mapping["Default"]
			for prefix in meshes.mapping:
				var f = meshes.mapping[prefix]
				if mesh.resource_name.begins_with(prefix):
					folder = f
					break
			var path = folder + mesh.resource_name + ".res"
			if ResourceSaver.save(mesh, path) != OK:
				push_error("failed to save mesh {0} to {1}".format([mesh.resource_name, path]))


	print_rich("[b]GODOT SYNTY ASSET HELPER:[/b] finished {0} pack import!".format([self.name]))
	EditorInterface.restart_editor()
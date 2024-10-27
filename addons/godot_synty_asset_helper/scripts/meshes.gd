const MATERIALS = preload("res://addons/godot_synty_asset_helper/scripts/materials.gd")
const FBX = preload("res://addons/godot_synty_asset_helper/scripts/fbx.gd")

static func from_pack(pack: Pack) -> Array[Mesh]:
	print_rich("[b]GODOT SYNTY ASSET HELPER:[/b] generating static meshes...")

	var fbx_file_paths = FBX.get_file_paths(pack)

	var materials_dir = pack.materials.target_folder
	var material_dict = MATERIALS.get_material_dict(pack)

	var meshes: Array[Mesh] = []
	for path: String in fbx_file_paths:
		var filename = path.split(".")[0]

		if filename.ends_with("Optimized"):
			push_warning("Skipping: Optimized FBXs not handled. ({1})".format([filename, path]))
			continue

		var fbx: PackedScene = load(path)

		if not fbx:
			push_warning("Failed to load {0}".format([path]))
		
		var node: Node = fbx.instantiate()
		node.name = filename

		var mesh_instances: Array[MeshInstance3D] = []
		_drill_for_mesh_instances(node, mesh_instances)

		for mesh_instance in mesh_instances:
			if material_dict.has(mesh_instance.name):
				var mesh_material_names = material_dict[mesh_instance.name]
				for i in range(mesh_material_names.size()):
					var mat_name = mesh_material_names[i]
					var material: StandardMaterial3D = load(materials_dir + mat_name + ".res")
					mesh_instance.mesh.surface_set_material(i, material)
			meshes.push_back(mesh_instance.mesh)
			
		node.queue_free()
	return meshes

static func _drill_for_mesh_instances(node: Node, mesh_instances: Array[MeshInstance3D]):
	if node is MeshInstance3D:
		mesh_instances.push_back(node)
	for child in node.get_children():
		_drill_for_mesh_instances(child, mesh_instances)

static func from_pack(pack: Pack) -> Array[StandardMaterial3D]:
	var materials: Array[StandardMaterial3D] = []
	var materials_directory = pack.materials.target_folder

	print_rich("[b]GODOT SYNTY ASSET HELPER ({0}):[/b] generating materials...".format([pack.name]))

	var file = FileAccess.open(pack.materials.mapping, FileAccess.ModeFlags.READ)
	var prefab_name
	var mesh_name

	var set = []

	while file.get_position() < file.get_length():
		var line = file.get_line().strip_edges()
		if line.begins_with("Slot:"):
			var material_name = line.split(" ")[1]
			var texture_name = line.split(" ")[-1]

			if set.find(material_name) != -1: continue
			set.push_back(material_name)
			
			if not texture_name.begins_with("("):
				push_warning("Setup script does not support custom shaders, or albedo texture is empty. ({0})".format([texture_name]))
				continue

			texture_name = texture_name.erase(0)
			texture_name = texture_name.erase(texture_name.length() - 1)

			var material = StandardMaterial3D.new()
			material.albedo_texture = load(pack.materials.source + texture_name + ".png")
			material.vertex_color_use_as_albedo = false
			if texture_name.begins_with("PFK_"):
				material.uv1_scale = Vector3(100, 100, 100)
				material.uv2_scale = Vector3(100, 100, 100)

			material.resource_name = material_name

			materials.push_back(material)
	return materials


static func get_material_dict(pack: Pack) -> Dictionary:
	var dict: Dictionary = {}
	
	var file = FileAccess.open(pack.materials.mapping, FileAccess.ModeFlags.READ)

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

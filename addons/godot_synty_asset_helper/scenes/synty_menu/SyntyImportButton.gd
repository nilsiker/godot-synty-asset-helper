@tool
extends Button

signal import_pressed(pack_name: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)

	var config_path = "res://addons/godot_synty_asset_helper/{0}/config.json".format([name])

	var config = JSON.parse_string(FileAccess.get_file_as_string(config_path))
	
	disabled = not DirAccess.dir_exists_absolute(config.source_files)

func _on_pressed():
	import_pressed.emit(name)

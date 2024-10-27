@tool
extends EditorPlugin

const SyntyMenu = preload("res://addons/godot_synty_asset_helper/scenes/synty_menu/synty_menu.tscn")
	

var synty_menu

func _enter_tree() -> void:
	synty_menu = SyntyMenu.instantiate()
	add_control_to_dock(DockSlot.DOCK_SLOT_LEFT_UR, synty_menu)

	# if not ProjectSettings.has_setting("godot_synty_asset_helper/export_folder"):
	# 	ProjectSettings.set_setting("godot_synty_asset_helper/export_folder", "res://assets/synty/")
	# 	ProjectSettings.set_setting("godot_synty_asset_helper/organize_by_resource_type", false)
		

func _exit_tree() -> void:
	remove_control_from_docks(synty_menu)
	synty_menu.queue_free()
	synty_menu = null

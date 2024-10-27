@tool
extends Control

func _on_import_button_pressed(name: String):
    Pack.new(name).import()
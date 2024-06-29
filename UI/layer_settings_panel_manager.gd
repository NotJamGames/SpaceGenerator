extends MarginContainer


@export var panels : Array[LayerControlPanel]
@export var palette_editor : PanelContainer

var open_panel_index : int = -1

signal lock_tabs_requested()
signal unlock_tabs_requested()


func configure_and_open_panel\
		(layer_control : LayerControl, layer : GeneratorLayer,
		new_panel_index : int) -> void:
	if open_panel_index != -1: close_panel()

	open_panel_index = new_panel_index
	panels[new_panel_index].configure_and_open(layer_control, layer)


func close_panel() -> void:
	if open_panel_index == -1: return

	panels[open_panel_index].close()
	open_panel_index = -1


func open_palette_editor(layer : NebulaLayer) -> void:
	if open_panel_index != -1:
		panels[open_panel_index].visible = false

	for layer_control : Node in get_tree().get_nodes_in_group("LayerControls"):
		layer_control = layer_control as LayerControl
		if layer_control == null:
			push_error("Node %s not of type LayerControl" % layer_control.name)
			continue
		layer_control.set_locked(true)

	palette_editor.configure_and_open(layer)
	lock_tabs_requested.emit()


func close_palette_editor() -> void:
	palette_editor.close()
	if open_panel_index != -1:
		panels[open_panel_index].visible = true

	for layer_control : Node in get_tree().get_nodes_in_group("LayerControls"):
		layer_control = layer_control as LayerControl
		if layer_control == null:
			push_error("Node %s not of type LayerControl" % layer_control.name)
			continue
		layer_control.set_locked(false)

	unlock_tabs_requested.emit()

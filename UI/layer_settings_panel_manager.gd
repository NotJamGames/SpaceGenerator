extends MarginContainer


@export var panels : Array[LayerControlPanel]

var open_panel_index : int = -1


func configure_and_open_panel\
		(layer_control : LayerControl, layer : GeneratorLayer,
		new_panel_index : int) -> void:
	if open_panel_index != -1: close_panel()

	open_panel_index = new_panel_index
	panels[new_panel_index].configure_and_open(layer_control, layer)


func close_panel() -> void:
	if open_panel_index == -1: return

	panels[open_panel_index].visible = false
	open_panel_index = -1

extends LayerControlPanel


var layer : GeneratorLayer

var closed : bool = true


func configure_and_open\
		(layer_control : LayerControl, new_layer : GeneratorLayer) -> void:
	name_edit.text = layer_control.label.text

	layer = new_layer as NebulaLayer
	if layer == null:
		push_error("Error: layer not of type NebulaLayer")

	closed = false
	visible = true


func close() -> void:
	visible = false
	closed = true

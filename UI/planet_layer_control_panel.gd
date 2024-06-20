extends LayerControlPanel


var layer : PlanetLayer


func configure_and_open\
		(layer_control : LayerControl, new_layer : GeneratorLayer) -> void:
	name_edit.text = layer_control.label.text

	layer = new_layer as PlanetLayer
	if layer == null:
		push_error("Error: layer not of type PlanetLayer")

	closed = false
	visible = true


func update_speed(value : float) -> void:
	layer.set_speed(value)

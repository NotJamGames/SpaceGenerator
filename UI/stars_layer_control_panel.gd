extends LayerControlPanel


func configure_and_open\
		(layer_control : LayerControl, layer : GeneratorLayer) -> void:
	name_edit.text = layer_control.label.text

	visible = true

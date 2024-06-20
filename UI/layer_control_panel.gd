class_name LayerControlPanel
extends PanelContainer


@export var name_edit : LineEdit


var closed : bool = true


func close() -> void:
	visible = false
	closed = true

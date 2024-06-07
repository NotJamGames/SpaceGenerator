class_name ColorSetting
extends VBoxContainer


@export var color : Color : set = set_color
@export var weight : int : set = set_weight

@export var color_picker_button : ColorPickerButton
@export var weight_spin_box : SpinBox


signal color_changed


func set_color(new_color : Color) -> void:
	color = new_color
	color_picker_button.color = new_color


func set_color_and_push_update(new_color : Color) -> void:
	set_color(new_color)
	color_changed.emit()


func set_weight(new_weight : float) -> void:
	weight = new_weight
	weight_spin_box.value = new_weight


func set_weight_and_push_update(new_weight : float) -> void:
	set_weight(new_weight)
	color_changed.emit()

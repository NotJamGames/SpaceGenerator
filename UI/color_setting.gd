class_name ColorSetting
extends VBoxContainer


@export var color : Color : set = set_color
@export var weight : int : set = set_weight

@export var move_up_button : TextureButton
@export var move_down_button : TextureButton
@export var color_picker_button : ColorPickerButton
@export var weight_spin_box : SpinBox


signal color_changed()
signal weight_changed()
signal position_moved()
signal deletion_requested()


func set_color(new_color : Color) -> void:
	color = new_color
	color_picker_button.color = new_color


func set_color_and_push_update(new_color : Color) -> void:
	set_color(new_color)
	color_changed.emit()


func set_weight(new_weight : int) -> void:
	weight = new_weight
	weight_spin_box.value = new_weight


func set_weight_and_push_update(new_weight : int) -> void:
	var mod : int = new_weight - weight
	set_weight(new_weight)
	weight_changed.emit(mod)
	color_changed.emit()


func evaluate_position() -> void:
	var index : int = get_index()
	move_up_button.disabled = index == 0
	move_down_button.disabled = index == get_parent().get_child_count() - 1


func move_position(direction : int) -> void:
	get_parent().move_child(self, get_index() + direction)
	position_moved.emit()


func request_deletion() -> void:
	deletion_requested.emit(self)

class_name LayerControl
extends PanelContainer


const LAYER_CONTROL_SELECTED_STYLEBOX : StyleBox = preload\
		("res://UI/Styleboxes/layer_control_selected.tres")
const LAYER_CONTROL_UNSELECTED_STYLEBOX : StyleBox = preload\
		("res://UI/Styleboxes/layer_control_unselected.tres")


@export var label : Label
@export var matched_layer : GeneratorLayer


var selected : bool = false


signal was_selected()
signal request_deletion()


func check_toggle_selected(event : InputEvent) -> void:
	event = event as InputEventMouseButton
	if event == null: return
	if not event.is_released(): return

	if selected:
		toggle_selected(false)
		return

	was_selected.emit(self, matched_layer)
	toggle_selected(true)


func toggle_selected(new_state : bool) -> void:
	selected = new_state

	if new_state:
		add_theme_stylebox_override("panel", LAYER_CONTROL_SELECTED_STYLEBOX)
	else:
		add_theme_stylebox_override("panel", LAYER_CONTROL_UNSELECTED_STYLEBOX)


func toggle_visible(new_state : bool) -> void:
	matched_layer.visible = !new_state


func delete() -> void:
	request_deletion.emit(label.text, [matched_layer, self])

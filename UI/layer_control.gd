class_name LayerControl
extends PanelContainer


const LAYER_CONTROL_SELECTED_STYLEBOX : StyleBox = preload\
		("res://UI/Styleboxes/layer_control_selected.tres")
const LAYER_CONTROL_UNSELECTED_STYLEBOX : StyleBox = preload\
		("res://UI/Styleboxes/layer_control_unselected.tres")


@export var label : Label
@export var matched_layer : GeneratorLayer
@export var move_up_button : TextureButton
@export var move_down_button : TextureButton


@export var matched_layer_type : SpaceGenerator.LayerTypes


@export var locked_icon : TextureRect


var selected : bool = false
var locked : bool = false


signal was_selected()
signal was_deselected()
signal request_deletion()
signal reorder_requested(layer : GeneratorLayer, direction : int)


func _ready() -> void:
	add_to_group("LayerControls")

	if label.text != "": return
	match matched_layer_type:
		SpaceGenerator.LayerTypes.STAR_LAYER:
			label.text = "Star Layer"
		SpaceGenerator.LayerTypes.NEBULA_LAYER:
			label.text = "Nebula Layer"
		SpaceGenerator.LayerTypes.PLANET_LAYER:
			label.text = "Planet Layer"


func check_toggle_selected(event : InputEvent) -> void:
	event = event as InputEventMouseButton
	if event == null or locked: return
	if event.button_index != MOUSE_BUTTON_LEFT\
	or !event.is_released():
		return

	if selected:
		toggle_selected(false)
		return

	was_selected.emit(self, matched_layer, matched_layer_type)
	toggle_selected(true)


func toggle_selected(new_state : bool) -> void:
	selected = new_state

	if new_state:
		add_theme_stylebox_override("panel", LAYER_CONTROL_SELECTED_STYLEBOX)
	else:
		add_theme_stylebox_override("panel", LAYER_CONTROL_UNSELECTED_STYLEBOX)
		was_deselected.emit()


func reorder_layer(direction : int) -> void:
	get_parent().move_child(self, get_index() + direction)
	evaluate_position()
	reorder_requested.emit(matched_layer, direction)


func toggle_visible(new_state : bool) -> void:
	matched_layer.visible = !new_state


func delete() -> void:
	request_deletion.emit(label.text, [matched_layer, self])


func set_locked(new_state : bool) -> void:
	locked = new_state
	locked_icon.visible = locked


func evaluate_position() -> void:
	var index : int = get_index()
	move_up_button.disabled = index == 0
	move_down_button.disabled = index == get_parent().get_child_count() - 1

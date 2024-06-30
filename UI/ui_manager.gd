class_name UIManager
extends Control


@export var left_panel : PanelContainer
@export var right_panel : MarginContainer
@export var menu_tab_container : TabContainer

const LAYER_CONTROL_RESOURCE : Resource = \
		preload("res://UI/layer_control.tscn")
@export var layer_controls_vbox : VBoxContainer
@export var add_layer_button : Button

@export var preset_name_line_edit : LineEdit
@export var resolution_interface : HBoxContainer
@export var preset_manager : PresetManager

@export var add_layer_dialogue : ColorRect
@export var delete_layer_dialogue : ColorRect
@export var delete_layer_dialogue_label : Label
@export var load_preset_dialogue : LoadPresetDialogue

@export var duplicate_layer_button : DuplicateLayerButton

var active_layer_control : LayerControl
var queued_deletions : Array = []

signal layer_added(layer_type : SpaceGenerator.LayerTypes)
signal layer_duplicated(source_layer : GeneratorLayer)
signal reorder_requested(layer : GeneratorLayer, direction : int)
signal preset_load_requested(preset_data : Dictionary)
signal preset_upload_requested()
signal export_requested(export_type : SpaceGenerator.ExportTypes)


func _ready() -> void:
	layer_controls_reevaluate_positions()


func _input(event : InputEvent) -> void:
	if !event is InputEventKey: return

	if event.is_action_pressed("duplicate") and Input.is_action_pressed("ctrl"):
		duplicate_layer()


func toggle_left_panel(new_state : bool) -> void:
	left_panel.visible = new_state

	if right_panel.open_panel_index != -1:
		right_panel.visible = new_state


func toggle_layer\
		(layer_control : LayerControl, layer : GeneratorLayer,
		layer_type : int) -> void:
	deselect_active_layer_control()

	active_layer_control = layer_control
	duplicate_layer_button.set_disabled_with_cursor_override(false)

	right_panel.configure_and_open_panel(layer_control, layer, layer_type)


func _on_tab_changed(tab : int) -> void:
	if tab != 0: close_layer_panel()
	deselect_active_layer_control()


func deselect_active_layer_control() -> void:
	if active_layer_control != null: active_layer_control.toggle_selected(false)
	active_layer_control = null


func close_layer_panel() -> void:
	right_panel.close_panel()
	duplicate_layer_button.set_disabled_with_cursor_override(true)


func lock_tabs() -> void:
	for i : int in range(1,4):
		menu_tab_container.set_tab_disabled(i, true)
	add_layer_button.set_disabled_with_cursor_override(true)
	duplicate_layer_button.set_disabled_with_cursor_override(true)


func unlock_tabs() -> void:
	for i : int in menu_tab_container.get_tab_count():
		menu_tab_container.set_tab_disabled(i, false)
	add_layer_button.set_disabled_with_cursor_override(false)
	duplicate_layer_button.set_disabled_with_cursor_override(false)


func query_create_layer() -> void:
	if active_layer_control != null:
		active_layer_control.toggle_selected(false)

	add_layer_dialogue.visible = true


func create_layer(new_layer_type : SpaceGenerator.LayerTypes) -> void:
	add_layer_dialogue.visible = false
	layer_added.emit(new_layer_type)


func cancel_create_layer() -> void:
	add_layer_dialogue.visible = false


func duplicate_layer() -> void:
	if active_layer_control == null: return
	layer_duplicated.emit(active_layer_control.matched_layer)


func request_layer_reorder(layer : GeneratorLayer, direction : int) -> void:
	reorder_requested.emit(layer, direction)
	layer_controls_reevaluate_positions()


func layer_controls_reevaluate_positions() -> void:
	for layer_control : Node in layer_controls_vbox.get_children():
		layer_control = layer_control as LayerControl
		if layer_control == null:
			push_error("Error: layer_controls_vbox has child not of type LayerControl")
			continue

		layer_control.evaluate_position()


func add_layer_control\
		(layer : GeneratorLayer, layer_type : SpaceGenerator.LayerTypes,
		layer_title : String) -> void:
	var new_layer_control : LayerControl = LAYER_CONTROL_RESOURCE.instantiate()
	new_layer_control.label.text = layer_title
	new_layer_control.matched_layer = layer
	new_layer_control.matched_layer_type = layer_type
	new_layer_control.request_deletion.connect(query_delete_layer)
	new_layer_control.was_deselected.connect(close_layer_panel)
	new_layer_control.was_selected.connect(toggle_layer)
	new_layer_control.reorder_requested.connect(request_layer_reorder)
	layer_controls_vbox.add_child(new_layer_control)
	new_layer_control.toggle_selected(true)
	new_layer_control.evaluate_position()
	toggle_layer(new_layer_control, layer, layer_type)
	layer_controls_reevaluate_positions()


func query_delete_layer(layer_name : String, to_delete : Array) -> void:
	delete_layer_dialogue_label.text = "Delete Layer: %s?" % layer_name
	delete_layer_dialogue.visible = true
	queued_deletions = to_delete


func confirm_delete_layer() -> void:
	for node : Node in queued_deletions:
		node.queue_free()
		await node.tree_exited

	delete_layer_dialogue.visible = false
	right_panel.close_panel()
	right_panel.close_palette_editor()

	layer_controls_reevaluate_positions()


func cancel_delete_layer() -> void:
	delete_layer_dialogue.visible = false


func delete_all_layer_controls() -> void:
	for layer_control : Node in layer_controls_vbox.get_children():
		layer_control.queue_free()


func update_layer_name(new_name : String) -> void:
	active_layer_control.label.text = new_name


func confirm_load_preset(preset_data : Dictionary) -> void:
	if await load_preset_dialogue.confirm_load_preset():
		preset_load_requested.emit(preset_data)
	return


func request_preset_upload() -> void:
	preset_upload_requested.emit()


func request_export(export_type : SpaceGenerator.ExportTypes) -> void:
	export_requested.emit(export_type)

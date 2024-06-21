class_name UIManager
extends Control


@export var left_panel : PanelContainer
@export var right_panel : MarginContainer

const LAYER_CONTROL_RESOURCE : Resource = \
		preload("res://UI/layer_control.tscn")
@export var layer_controls_vbox : VBoxContainer

@export var add_layer_dialogue : ColorRect
@export var delete_layer_dialogue : ColorRect
@export var delete_layer_dialogue_label : Label

@export var duplicate_layer_button : DuplicateLayerButton

var active_layer_control : LayerControl
var queued_deletions : Array = []

signal layer_added(layer_type : SpaceGenerator.LayerTypes)
signal layer_duplicated(source_layer : GeneratorLayer)
signal reorder_requested(layer : GeneratorLayer, direction : int)


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
	if active_layer_control != null:
		active_layer_control.toggle_selected(false)

	active_layer_control = layer_control
	duplicate_layer_button.set_disabled_with_cursor_override(false)

	right_panel.configure_and_open_panel(layer_control, layer, layer_type)


func close_layer_panel() -> void:
	right_panel.close_panel()
	duplicate_layer_button.set_disabled_with_cursor_override(true)


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
		(layer : GeneratorLayer, layer_type : SpaceGenerator.LayerTypes)\
		-> void:
	var new_layer_control : LayerControl = LAYER_CONTROL_RESOURCE.instantiate()
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


func update_layer_name(new_name : String) -> void:
	active_layer_control.label.text = new_name

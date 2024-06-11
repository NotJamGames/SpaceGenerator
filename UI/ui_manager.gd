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

var active_layer_control : LayerControl
var queued_deletions : Array = []

signal layer_added(layer_type : SpaceGenerator.LayerTypes)


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

	right_panel.configure_and_open_panel(layer_control, layer, layer_type)


func close_layer_panel() -> void:
	right_panel.close_panel()


func query_create_layer() -> void:
	if active_layer_control != null:
		active_layer_control.toggle_selected(false)

	add_layer_dialogue.visible = true


func create_layer(new_layer_type : SpaceGenerator.LayerTypes) -> void:
	add_layer_dialogue.visible = false
	layer_added.emit(new_layer_type)


func cancel_create_layer() -> void:
	add_layer_dialogue.visible = false


func add_layer_control\
		(layer : GeneratorLayer, layer_type : SpaceGenerator.LayerTypes)\
		-> void:
	var new_layer_control : LayerControl = LAYER_CONTROL_RESOURCE.instantiate()
	new_layer_control.matched_layer = layer
	new_layer_control.matched_layer_type = layer_type
	new_layer_control.request_deletion.connect(query_delete_layer)
	new_layer_control.was_deselected.connect(close_layer_panel)
	new_layer_control.was_selected.connect(toggle_layer)
	layer_controls_vbox.add_child(new_layer_control)
	new_layer_control.toggle_selected(true)
	toggle_layer(new_layer_control, layer, layer_type)


func query_delete_layer(layer_name : String, to_delete : Array) -> void:
	delete_layer_dialogue_label.text = "Delete Layer: %s?" % layer_name
	delete_layer_dialogue.visible = true
	queued_deletions = to_delete


func confirm_delete_layer() -> void:
	for node : Node in queued_deletions:
		node.queue_free()

	delete_layer_dialogue.visible = false
	right_panel.close_panel()
	right_panel.close_palette_editor()


func cancel_delete_layer() -> void:
	delete_layer_dialogue.visible = false


func update_layer_name(new_name : String) -> void:
	active_layer_control.label.text = new_name

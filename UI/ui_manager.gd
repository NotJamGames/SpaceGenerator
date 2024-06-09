extends Control


@export var left_panel : PanelContainer
@export var right_panel : MarginContainer

@export var delete_layer_dialogue : ColorRect
@export var delete_layer_dialogue_label : Label

var active_layer_control : LayerControl
var queued_deletions : Array = []


func toggle_panel(new_state : bool, panel_ref : String) -> void:
	var panel : PanelContainer = get(panel_ref) as PanelContainer
	if panel == null:
		push_error("Error: panel %s not found" % panel_ref)
		return

	panel.visible = new_state
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


func create_layer() -> void:
	pass
	# remember to connect layer's signals here


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

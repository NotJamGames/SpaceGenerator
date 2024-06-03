extends Control


@export var left_panel : PanelContainer

@export var delete_layer_dialogue : ColorRect
@export var delete_layer_dialogue_label : Label


var queued_deletions : Array = []


func toggle_panel(new_state : bool, panel_ref : String) -> void:
	var panel : PanelContainer = get(panel_ref) as PanelContainer
	if panel == null:
		push_error("Error: panel %s not found" % panel_ref)
		return

	panel.visible = new_state


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


func cancel_delete_layer() -> void:
	delete_layer_dialogue.visible = false

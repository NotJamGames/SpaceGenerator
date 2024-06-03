extends Control


@export var left_panel : Array[PanelContainer]

@export var delete_layer_dialogue : ColorRect
@export var delete_layer_dialogue_label : Label


var queued_deletions : Array = []


func toggle_panel(panel_ref : String) -> void:
	print("h")
	var panels : Array[PanelContainer] = get(panel_ref)
	if panels == null:
		push_error("Error: panel %s not found" % panel_ref)
		return

	for panel : PanelContainer in panels:
		panel.visible = !panel.visible


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

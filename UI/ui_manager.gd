extends HBoxContainer


@export var left_panel : Array[PanelContainer]


func toggle_panel(panel_ref : String) -> void:
	var panels : Array[PanelContainer] = get(panel_ref)
	if panels == null:
		push_error("Error: panel %s not found" % panel_ref)
		return

	for panel : PanelContainer in panels:
		panel.visible = !panel.visible

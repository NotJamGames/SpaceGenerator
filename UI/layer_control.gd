extends HBoxContainer


@export var line_edit : LineEdit
@export var matched_layer : GeneratorLayer


signal request_deletion()


func toggle_visible(new_state : bool) -> void:
	matched_layer.visible = !new_state


func delete() -> void:
	request_deletion.emit(line_edit.text, [matched_layer, self])

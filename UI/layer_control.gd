extends HBoxContainer


@export var matched_layer : GeneratorLayer


func toggle_visible(new_state : bool) -> void:
	matched_layer.visible = !new_state

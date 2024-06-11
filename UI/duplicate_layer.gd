class_name DuplicateLayerButton
extends Button


func set_disabled_with_cursor_override(new_state : bool) -> void:
	disabled = new_state
	if new_state:
		mouse_default_cursor_shape = Control.CURSOR_ARROW
	else:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

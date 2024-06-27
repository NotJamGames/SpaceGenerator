class_name LoadPresetDialogue
extends ColorRect


signal user_responded(response : bool)


func confirm_load_preset() -> bool:
	visible = true
	return await user_responded


func confirm() -> void:
	visible = false
	user_responded.emit(true)


func cancel() -> void:
	visible = false
	user_responded.emit(false)

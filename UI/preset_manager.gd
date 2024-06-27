class_name PresetManager
extends VBoxContainer


signal load_preset_requested(preset_data : Dictionary)


func add_preset_button(preset_data : Dictionary) -> void:
	var button : Button = Button.new()
	button.text = "preset!"
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.pressed.connect(request_load_preset.bind(preset_data))
	add_child(button)
	move_child(button, get_child_count() - 2)


func request_load_preset(preset_data : Dictionary) -> void:
	load_preset_requested.emit(preset_data)

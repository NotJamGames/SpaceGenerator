class_name PresetManager
extends VBoxContainer


@export var presets : Array[Resource]


signal load_preset_requested(preset_data : Dictionary)


func _ready() -> void:
	for preset_resource : Resource in presets:
		var preset_data : JSON = preset_resource as JSON
		if preset_data == null:
			push_error("Error: attempting to load preset not of type JSON")
			continue
		add_preset_button(preset_data.data)


func add_preset_button(preset_data : Dictionary) -> void:
	var button : Button = Button.new()
	button.text = preset_data["preset_name"]
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.pressed.connect(request_load_preset.bind(preset_data))
	add_child(button)
	move_child(button, get_child_count() - 2)


func request_load_preset(preset_data : Dictionary) -> void:
	load_preset_requested.emit(preset_data)

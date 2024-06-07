extends Control


const COLOR_SETTING_RESOURCE : Resource = preload\
		("res://UI/color_setting.tscn")

@export var color_setting_vbox : VBoxContainer
@export var palette : Texture


func _ready() -> void:
	evaluate_palette(palette)


func evaluate_palette(new_palette : Texture) -> void:
	var palette_image : Image = new_palette.get_image()

	var palette_size = palette_image.get_width()
	var palette_colors : Array[Array] = []
	for i : int in palette_size:
		var new_color : Color = palette_image.get_pixel(i, 0)
		if palette_colors.size() == 0:
			palette_colors.append([new_color, 1])
		elif new_color.is_equal_approx(palette_colors.back()[0]):
			var new_palette_entry : Array = palette_colors.pop_back()
			new_palette_entry[1] = new_palette_entry[1] + 1
			palette_colors.append(new_palette_entry)
		else:
			palette_colors.append([new_color, 1])

	for color_setting : Array in palette_colors:
		var new_color_setting : ColorSetting = \
				COLOR_SETTING_RESOURCE.instantiate()
		new_color_setting.color = color_setting[0]
		new_color_setting.weight = color_setting[1]
		color_setting_vbox.add_child(new_color_setting)


func generate_palette() -> void:
	pass

extends PanelContainer


const COLOR_SETTING_RESOURCE : Resource = preload\
		("res://UI/color_setting.tscn")

@export var color_setting_vbox : VBoxContainer
var previous_palette : Texture
var palette_size : int = 0

var color_setting_nodes : Array[ColorSetting]

var layer : NebulaLayer

signal editor_closed()


func configure_and_open(new_layer : NebulaLayer) -> void:
	layer = new_layer
	evaluate_palette(layer.palette)
	visible = true


func close() -> void:
	for color_setting : Node in color_setting_vbox.get_children():
		color_setting = color_setting as ColorSetting
		if color_setting == null: continue

		color_setting.queue_free()

	visible = false


func evaluate_palette(new_palette : Texture) -> void:
	previous_palette = new_palette
	var palette_image : Image = new_palette.get_image()

	palette_size = palette_image.get_width()
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
		color_setting_nodes.append(new_color_setting)

		new_color_setting.weight_changed.connect(increment_palette_size)
		new_color_setting.color_changed.connect(generate_palette)


func generate_palette() -> void:
	var new_palette : Image = Image.create\
			(palette_size, 1, false, Image.FORMAT_RGBAF)
	var x_pos : int = 0

	for color_setting : Node in color_setting_vbox.get_children():
		color_setting = color_setting as ColorSetting
		if color_setting == null: continue

		for i : int in color_setting.weight:
			new_palette.set_pixel(x_pos, 0, color_setting.color)
			x_pos += 1

	layer.set_palette(ImageTexture.create_from_image(new_palette))


func confirm_palette() -> void:
	editor_closed.emit()


func cancel_palette() -> void:
	layer.set_palette(previous_palette)
	editor_closed.emit()


func add_color_setting() -> void:
	var new_color_setting : ColorSetting = COLOR_SETTING_RESOURCE.instantiate()
	new_color_setting.color = Color.WHITE
	new_color_setting.weight = 1
	color_setting_vbox.add_child(new_color_setting)

	generate_palette()


func increment_palette_size(mod : int) -> void:
	palette_size += mod

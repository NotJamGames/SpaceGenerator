extends LayerControlPanel


@export var threshold_slider : HSlider
@export var density_slider : HSlider
@export var alpha_slider : HSlider
@export var dither_checkbox : CheckBox

@export var modulation_checkbox : CheckBox
@export var modulation_color_picker_button : ColorPickerButton
@export var modulation_intensity_slider : HSlider
@export var modulation_alpha_intensity_slider : HSlider
@export var modulation_steps_spin_box : SpinBox

@export var oscillation_checkbox : CheckBox
@export var modulation_settings_submenu : VBoxContainer
@export var oscillation_settings_submenu : VBoxContainer
@export var oscillation_intensity_slider : HSlider
@export var oscillation_rate_slider : HSlider
@export var oscillation_offset_slider : HSlider
@export var speed_slider : HSlider

var layer : NebulaLayer

signal open_palette_editor_requested()


func configure_and_open\
		(layer_control : LayerControl, new_layer : GeneratorLayer) -> void:
	name_edit.text = layer_control.label.text

	layer = new_layer as NebulaLayer
	if layer == null:
		push_error("Error: layer not of type NebulaLayer")

	threshold_slider.value = layer.threshold
	density_slider.value = layer.density
	alpha_slider.value = layer.alpha
	dither_checkbox.button_pressed = layer.dither_enabled

	modulation_checkbox.button_pressed = layer.modulation_enabled
	modulation_color_picker_button.color = layer.modulation_color
	modulation_intensity_slider.value = layer.modulation_intensity
	modulation_alpha_intensity_slider.value = layer.modulation_alpha_intensity
	modulation_steps_spin_box.value = layer.modulation_steps

	oscillation_checkbox.button_pressed = layer.oscillate
	oscillation_intensity_slider.value = layer.oscillation_intensity
	oscillation_rate_slider.value = layer.oscillation_rate
	oscillation_offset_slider.value = layer.oscillation_rate
	speed_slider.value = layer.speed

	closed = false
	visible = true


func request_open_palette_editor() -> void:
	open_palette_editor_requested.emit(layer)


func update_threshold(new_value : float) -> void:
	layer.threshold = new_value


func update_density(new_value : float) -> void:
	layer.density = new_value


func update_alpha(new_value : float) -> void:
	layer.alpha = new_value


func update_dither_enabled(new_state : bool) -> void:
	layer.dither_enabled = new_state


func update_oscillate(new_state : bool) -> void:
	layer.oscillate = new_state
	oscillation_settings_submenu.visible = new_state


func update_oscillation_intensity(new_value : float) -> void:
	layer.oscillation_intensity = new_value


func update_oscillation_rate(new_value : float) -> void:
	layer.oscillation_rate = new_value


func update_oscillation_offset(new_value : float) -> void:
	layer.oscillation_offset = new_value


func update_modulation_enabled(new_state : bool) -> void:
	layer.modulation_enabled = new_state
	modulation_settings_submenu.visible = new_state


func update_modulation_color(new_color : Color) -> void:
	layer.modulation_color = new_color


func update_modulation_intensity(new_value : float) -> void:
	layer.modulation_intensity = new_value


func update_modulation_alpha_intensity(new_value : float) -> void:
	layer.modulation_alpha_intensity = new_value


func update_modulation_density(new_value : float) -> void:
	layer.modulation_density = new_value


func update_modulation_steps(new_value : int) -> void:
	layer.modulation_steps = new_value


func update_speed(new_value : float) -> void:
	layer.speed = new_value


func request_new_seed():
	layer.new_seed()

extends LayerControlPanel


# TODO: figure out how to implement palettes
# and fix this
@export var palette_button : Control

@export var threshold_slider : HSlider
@export var alpha_slider : HSlider
@export var dither_checkbox : CheckBox

@export var oscillation_checkbox : CheckBox
@export var oscillation_intensity_slider : HSlider
@export var oscillation_rate_slider : HSlider
@export var oscillation_offset_slider : HSlider
@export var speed_slider : HSlider


var layer : GeneratorLayer

var closed : bool = true


func configure_and_open\
		(layer_control : LayerControl, new_layer : GeneratorLayer) -> void:
	name_edit.text = layer_control.label.text

	layer = new_layer as NebulaLayer
	if layer == null:
		push_error("Error: layer not of type NebulaLayer")

	threshold_slider.value = layer.threshold
	alpha_slider.value = layer.alpha
	dither_checkbox.button_pressed = layer.dither_enabled

	oscillation_checkbox.button_pressed = layer.oscillate
	oscillation_intensity_slider.value = layer.oscillation_intensity
	oscillation_rate_slider.value = layer.oscillation_rate
	oscillation_offset_slider.value = layer.oscillation_rate
	speed_slider.value = layer.speed
	

	closed = false
	visible = true


func close() -> void:
	visible = false
	closed = true


func update_threshold(new_value : float) -> void:
	layer.threshold = new_value


func update_alpha(new_value : float) -> void:
	layer.alpha = new_value


func update_dither_enabled(new_state : bool) -> void:
	layer.dither_enabled = new_state


func update_oscillate(new_state : bool) -> void:
	layer.oscillate = new_state


func update_oscillation_intensity(new_value : float) -> void:
	layer.oscillation_intensity = new_value


func update_oscillation_rate(new_value : float) -> void:
	layer.oscillation_rate = new_value


func update_oscillation_offset(new_value : float) -> void:
	layer.oscillation_offset = new_value


func update_speed(new_value : float) -> void:
	layer.speed = new_value


func request_new_seed():
	layer.new_seed()

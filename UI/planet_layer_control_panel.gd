extends LayerControlPanel


@export var spawn_interval_hrange_slider : HRangeSlider
@export var max_concurrent_planets_spin_box : SpinBox


@export var scroll_speed_slider : HSlider


var layer : PlanetLayer


func configure_and_open\
		(layer_control : LayerControl, new_layer : GeneratorLayer) -> void:
	name_edit.text = layer_control.label.text

	layer = new_layer as PlanetLayer
	if layer == null:
		push_error("Error: layer not of type PlanetLayer")

	closed = false
	visible = true

	spawn_interval_hrange_slider.minimum_value = layer.min_spawn_frequency
	spawn_interval_hrange_slider.maximum_value = layer.max_spawn_frequency
	max_concurrent_planets_spin_box.value = layer.max_concurrent_planets
	scroll_speed_slider.value = layer.speed


func update_spawn_interval(new_min : float, new_max : float) -> void:
	layer.min_spawn_frequency = new_min
	layer.max_spawn_frequency = new_max


func update_max_concurrent_planets(new_value : int) -> void:
	layer.max_concurrent_planets = new_value


func update_speed(value : float) -> void:
	layer.set_speed(value)

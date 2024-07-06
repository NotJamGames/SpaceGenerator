extends LayerControlPanel


@export var star_quantity_slider : HSlider
@export var star_ratio_sliders : Array[HSlider]
@export var flicker_rate_slider : HSlider
@export var flicker_depth_slider : HSlider

@export var scroll_speed_slider : HSlider

var layer : StarLayer

var num_stars : int = 0
var ratio : Array[float] = [.0, .0, .0]
var speed : float


func configure_and_open\
		(layer_control : LayerControl, new_layer : GeneratorLayer) -> void:
	name_edit.text = layer_control.label.text

	layer = new_layer as StarLayer
	if layer == null:
		push_error("Error: layer not of type StarLayer")

	star_quantity_slider.value = layer.max_stars
	flicker_rate_slider.value = layer.flicker_rate
	flicker_depth_slider.value = layer.flicker_depth

	ratio.clear()
	ratio.append_array(layer.ratio)
	for i : int in ratio.size():
		star_ratio_sliders[i].value = ratio[i]

	scroll_speed_slider.value = layer.speed

	closed = false
	visible = true


func update_star_quantity(new_value : float) -> void:
	num_stars = int(new_value)


func update_star_ratio(new_value : float, index : int) -> void:
	ratio[index] = new_value


func update_flicker_rate(new_value : float) -> void:
	layer.flicker_rate = new_value


func update_flicker_depth(new_value : float) -> void:
	layer.flicker_depth = new_value


func update_layer_speed(new_value : float) -> void:
	layer.speed = new_value


func push_star_layer_update(value_changed : bool = true) -> void:
	if !value_changed or closed: return

	layer.generate_stars(num_stars, ratio, Vector2(360, 240))


func check_slider_click_and_release\
		(event : InputEvent, matched_function : String,
		bound_args : Array = [])\
		-> void:
	event = event as InputEventMouseButton
	if event == null: return

	if event.button_index != MOUSE_BUTTON_LEFT\
	or !event.is_released(): return

	if bound_args.size() > 0:
		call(matched_function).bindv(bound_args)
	else:
		call(matched_function)

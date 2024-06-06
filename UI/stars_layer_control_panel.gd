extends LayerControlPanel


var layer : StarLayer

var num_stars : int = 0


func configure_and_open\
		(layer_control : LayerControl, new_layer : GeneratorLayer) -> void:
	name_edit.text = layer_control.label.text

	layer = new_layer as StarLayer
	if layer == null:
		push_error("Error: layer not of type StarLayer")

	visible = true


func update_star_quantity(new_value : float) -> void:
	num_stars = int(new_value)


func push_star_quantity_update(value_changed : bool = true) -> void:
	if !value_changed: return

	# TODO: make this actually reflect star ratio
	# and user-specified screen size
	layer.generate_stars(num_stars, [.65, .25, .1], Vector2(360, 240))


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

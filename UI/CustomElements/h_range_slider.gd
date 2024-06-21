class_name HRangeSlider
extends VBoxContainer


@export var lower_grabber : Grabber
@export var upper_grabber : Grabber

@export var out_of_bounds_left : Panel
@export var in_bounds : Panel
@export var out_of_bounds_right : Panel


@export var minimum_minimum_value : float
var minimum_value : float
@export var maximum_maximum_value : float
var maximum_value : float


var is_clicked : bool = false
var selected_grabber : Grabber


signal range_updated(min : float, max : float)


func _ready() -> void:
	lower_grabber.moved.connect(lower_grabber_moved)
	upper_grabber.moved.connect(upper_grabber_moved)
	configure_grabber_parameters()


func _input(event : InputEvent) -> void:
	if event.is_action_released("left_click"): is_clicked = false


func configure_grabber_parameters() -> void:
	if is_zero_approx(size.x): return

	upper_grabber.position.x = \
			(((maximum_value - minimum_minimum_value) \
			/ (maximum_maximum_value - minimum_minimum_value)) \
			* size.x) - 3
	upper_grabber_moved()

	lower_grabber.position.x = \
			((minimum_value - minimum_minimum_value) \
			/ (maximum_maximum_value - minimum_minimum_value)) \
			* size.x
	lower_grabber_moved()

	lower_grabber.x_origin = position.x
	lower_grabber.x_confine_lower = .0
	lower_grabber.x_confine_upper = upper_grabber.position.x - 1.0

	upper_grabber.x_origin = position.x
	upper_grabber.x_confine_lower = lower_grabber.position.x + 5.0
	upper_grabber.x_confine_upper = size.x - 4.0


func lower_grabber_moved() -> void:
	upper_grabber.x_confine_lower = lower_grabber.position.x + 6.0
	minimum_value = \
			minimum_minimum_value + \
			(
				(lower_grabber.position.x / size.x) \
				* (maximum_maximum_value - minimum_minimum_value)
			)

	in_bounds.position.x = lower_grabber.position.x + 3.0
	in_bounds.size.x = upper_grabber.position.x - lower_grabber.position.x
	out_of_bounds_left.size.x = lower_grabber.position.x + 3.0

	range_updated.emit(minimum_value, maximum_value)


func upper_grabber_moved() -> void:
	lower_grabber.x_confine_upper = upper_grabber.position.x - 6.0
	maximum_value = \
			minimum_minimum_value + \
			(
				(upper_grabber.position.x / size.x) \
				* (maximum_maximum_value - minimum_minimum_value) 
			)

	in_bounds.size.x = upper_grabber.position.x - lower_grabber.position.x
	out_of_bounds_right.position.x = upper_grabber.position.x + 3.0
	out_of_bounds_right.size.x = size.x - upper_grabber.position.x - 3.0

	range_updated.emit(minimum_value, maximum_value)


func move_undefined_slider(event : InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		is_clicked = true
		selected_grabber = get_closest_grabber(event.position.x)
		selected_grabber.update_position(event.position.x)

	if not event is InputEventMouseMotion or !is_clicked: return

	selected_grabber.update_position(event.position.x)


func get_closest_grabber(click_x_pos : float) -> Grabber:
	if click_x_pos < lower_grabber.position.x: return lower_grabber
	if click_x_pos > upper_grabber.position.x: return upper_grabber

	var distance_to_lower_grabber : float = \
			abs(lower_grabber.position.x - click_x_pos)
	var distance_to_upper_grabber : float = \
			abs(upper_grabber.position.x - click_x_pos)
	if distance_to_lower_grabber < distance_to_upper_grabber:
		return lower_grabber
	return upper_grabber

extends HBoxContainer


@export var x_line_edit : LineEdit
var previous_x : int
@export var y_line_edit : LineEdit
var previous_y : int

var resolution : Vector2i
signal resolution_confirmed(resolution : Vector2i)


func update_display(new_value : Vector2i) -> void:
	x_line_edit.text = str(new_value.x)
	previous_x = new_value.x
	y_line_edit.text = str(new_value.y)
	previous_y = new_value.y
	resolution = new_value


func confirm_resolution() -> void:
	resolution_confirmed.emit(resolution)


func update_x(new_text : String) -> void:
	if check_valid_int(new_text) > 0:
		resolution.x = new_text as int
		previous_x = new_text as int
	else: x_line_edit.text = str(previous_x)


func update_y(new_text : String) -> void:
	if check_valid_int(new_text) > 0:
		resolution.y = new_text as int
		previous_y = new_text as int
	else: y_line_edit.text = str(previous_y)


func check_valid_int(new_text : String) -> int:
	var text_as_int : int = new_text as int
	if text_as_int == null: return -1
	return text_as_int

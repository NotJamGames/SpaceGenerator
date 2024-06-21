class_name Grabber
extends Sprite2D


@export var parent_container : VBoxContainer


var is_clicked : bool = false
var x_confine_upper : float
var x_confine_lower : float
var x_origin : float

signal moved()


func _input(event : InputEvent) -> void:
	if event.is_action_released("left_click") and is_clicked:
		is_clicked = false

	if event is InputEventMouseMotion and is_clicked:
		update_position(event.position.x, -get_parent().global_position.x)


func update_position(target_x_pos : float, x_offset : float = .0) -> void:
	position.x = clamp\
			(target_x_pos + x_offset, x_confine_lower, x_confine_upper)
	moved.emit()


func _on_control_gui_input(event : InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		is_clicked = true

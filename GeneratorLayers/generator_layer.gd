class_name GeneratorLayer
extends TextureRect


@export_category("Layer Settings")
var index : int
@export var title : String : set = set_title
@export var resolution : Vector2i = Vector2i.ZERO : set = set_resolution
@export var speed : float = 32.0 : set = set_speed


func _process(delta : float) -> void:
	if Engine.is_editor_hint(): return
	position = lerp(position, Vector2(position.x, position.y + speed), delta)
	if position.y > .0:
		# don't divide size by 2 - consider scaling!
		position.y = position.y - (size.y)


func set_title(new_title : String) -> void:
	title = new_title


func set_resolution(new_resolution : Vector2i) -> void:
	resolution = new_resolution


func set_speed(new_value : float) -> void:
	speed = new_value

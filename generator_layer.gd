class_name GeneratorLayer
extends TextureRect


@export_category("Layer Settings")
@export var speed : float = 32.0


func _process(delta : float) -> void:
	if Engine.is_editor_hint(): return
	position = lerp(position, Vector2(position.x, position.y + speed), delta)
	if position.y > .0:
		# don't divide size by 2 - consider scaling!
		position.y = position.y - (size.y)

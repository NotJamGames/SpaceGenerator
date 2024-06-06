extends Node


@export var layers : Array[TextureRect]


@export var star_generator : StarLayer
@export var nebula_layers : Array[NebulaLayer]

@export var ui_manager : Control


func _ready() -> void:
	generate_space(Vector2i(360, 240))


func generate_space(new_size : Vector2i) -> void:
	for layer : NebulaLayer in nebula_layers:
		layer.build_nebula(Vector2i(new_size))

	star_generator.generate_stars(97, [65.0, 20.0, 15.0], new_size)


func generate_pngs() -> void:
	for layer : TextureRect in layers:
		var _new_image : Image = layer.texture.get_image()

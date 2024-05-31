extends Node


@export var subviewport : SubViewport
@export var star_generator : StarGenerator

@export var old_nebulae : Array[Sprite2D]
@export var nebula_layers : Array[NebulaLayer]


func _ready() -> void:
	generate_space(Vector2i(360, 240))


func generate_space(size : Vector2i) -> void:
	subviewport.size = size

	for nebula in old_nebulae:
		nebula.texture.noise.seed = randi()
		nebula.texture.width = size.x
		nebula.texture.height = size.y

	for layer : NebulaLayer in nebula_layers:
		layer.build_nebula(Vector2i(360, 240))

	star_generator.generate_stars(97, [65.0, 20.0, 15.0], size)

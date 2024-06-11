class_name SpaceGenerator
extends Node


@export var layers : Array[TextureRect]
@export var layer_container : Control


enum LayerTypes {STAR_LAYER, NEBULA_LAYER}
const STAR_LAYER_RESOURCE : Resource = \
		preload("res://GeneratorLayers/StarLayer/star_layer.tscn")
const NEBULA_LAYER_RESOURCE : Resource = \
		preload("res://GeneratorLayers/NebulaLayer/nebula_layer.tscn")
@export var star_generator : StarLayer
@export var nebula_layers : Array[NebulaLayer]

@export var export_resolution : Vector2i = Vector2i(360, 240)

@export var ui_manager : Control


func _ready() -> void:
	generate_space(export_resolution)


func generate_space(new_size : Vector2i) -> void:
	for layer : NebulaLayer in nebula_layers:
		layer.build_nebula(Vector2i(new_size))

	star_generator.generate_stars(192, [.65, .2, .15], new_size)


func generate_pngs() -> void:
	for layer : TextureRect in layers:
		var _new_image : Image = layer.texture.get_image()


func add_layer(layer_type : LayerTypes) -> void:
	var new_layer : GeneratorLayer
	match layer_type:
		LayerTypes.STAR_LAYER:
			new_layer = STAR_LAYER_RESOURCE.instantiate()
			layer_container.add_child(new_layer)
			var ratio : Array[float] = [.65, .2, .15]
			new_layer.generate_stars(192, ratio, export_resolution)
		LayerTypes.NEBULA_LAYER:
			new_layer = NEBULA_LAYER_RESOURCE.instantiate()
			layer_container.add_child(new_layer)
			new_layer.build_nebula(export_resolution)

	ui_manager.add_layer_control(new_layer, layer_type)

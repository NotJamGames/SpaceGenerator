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


func duplicate_layer(source_layer : GeneratorLayer) -> void:
	if source_layer is StarLayer:
		duplicate_star_layer(source_layer)
		return
	elif source_layer is NebulaLayer:
		duplicate_nebula_layer(source_layer)
		return
	push_error("Error: no method defined to duplicate provided layer")


func duplicate_star_layer(source_layer : StarLayer) -> void:
	var new_layer : StarLayer = STAR_LAYER_RESOURCE.instantiate()
	layer_container.add_child(new_layer)

	new_layer.generate_stars\
			(source_layer.max_stars, source_layer.ratio, export_resolution)
	new_layer.speed = source_layer.speed

	ui_manager.add_layer_control(new_layer, LayerTypes.STAR_LAYER)


func duplicate_nebula_layer(source_layer : NebulaLayer) -> void:
	var new_layer : NebulaLayer = NEBULA_LAYER_RESOURCE.instantiate()
	layer_container.add_child(new_layer)

	new_layer.set_palette(source_layer.palette)
	new_layer.set_threshold(source_layer.threshold)
	new_layer.set_alpha(source_layer.alpha)
	new_layer.set_dither_enabled(source_layer.dither_enabled)
	new_layer.set_oscillate(source_layer.oscillate)
	new_layer.set_oscillation_intensity(source_layer.oscillation_intensity)
	new_layer.set_oscillation_rate(source_layer.oscillation_rate)
	new_layer.set_oscillation_offset(source_layer.oscillation_offset)
	new_layer.speed = source_layer.speed

	new_layer.build_nebula(export_resolution)
	new_layer.noise_texture.noise.seed = source_layer.noise_texture.noise.seed

	ui_manager.add_layer_control(new_layer, LayerTypes.NEBULA_LAYER)

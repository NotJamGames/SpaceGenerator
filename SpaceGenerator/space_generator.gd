class_name SpaceGenerator
extends Node


@export var layers : Array[TextureRect]
@export var layer_container : Control


enum LayerTypes {STAR_LAYER, NEBULA_LAYER, PLANET_LAYER}
const STAR_LAYER_RESOURCE : Resource = \
		preload("res://GeneratorLayers/StarLayer/star_layer.tscn")
const NEBULA_LAYER_RESOURCE : Resource = \
		preload("res://GeneratorLayers/NebulaLayer/nebula_layer.tscn")
const PLANET_LAYER_RESOURCE : Resource = \
		preload("res://GeneratorLayers/PlanetLayer/planet_layer.tscn")

@export var nebula_layers : Array[NebulaLayer]
@export var star_layers : Array[StarLayer]
@export var planet_layers : Array[PlanetLayer]

@export var export_resolution : Vector2i = Vector2i(360, 240)

enum ExportTypes {PNG, PRESET}

@export var ui_manager : Control


func _ready() -> void:
	# export var doesn't work on web export for this one variable
	# I don't know why
	# This catches it, which will do for now 
	if layer_container == null: layer_container = $Layers

	generate_space(export_resolution)


func _input(event : InputEvent) -> void:
	if event.is_action_pressed("hide_ui"):
		ui_manager.visible = !ui_manager.visible


func generate_space(new_size : Vector2i) -> void:
	# this should work for resetting resolution, I think?
	export_resolution = new_size

	for layer : NebulaLayer in nebula_layers:
		layer.build_nebula(Vector2i(new_size))

	for layer : StarLayer in star_layers:
		layer.generate_stars(192, [.65, .2, .15], new_size)

	for layer : PlanetLayer in planet_layers:
		layer.set_size(new_size)


func generate_pngs() -> void:
	for layer : TextureRect in layers:
		var _new_image : Image = layer.texture.get_image()


func add_layer(layer_type : LayerTypes) -> void:
	var new_layer : GeneratorLayer
	var layer_title : String
	match layer_type:
		LayerTypes.STAR_LAYER:
			new_layer = STAR_LAYER_RESOURCE.instantiate()
			layer_container.add_child(new_layer)
			var ratio : Array[float] = [.65, .2, .15]
			new_layer.generate_stars(192, ratio, export_resolution)
			layer_title = "Star Layer"
			new_layer.title = layer_title
			star_layers.append(new_layer)
		LayerTypes.NEBULA_LAYER:
			new_layer = NEBULA_LAYER_RESOURCE.instantiate()
			layer_container.add_child(new_layer)
			new_layer.build_nebula(export_resolution)
			layer_title = "Nebula Layer"
			new_layer.title = layer_title
			nebula_layers.append(new_layer)
		LayerTypes.PLANET_LAYER:
			new_layer = PLANET_LAYER_RESOURCE.instantiate()
			layer_container.add_child(new_layer)
			new_layer.set_size(export_resolution)
			layer_title = "Planet Layer"
			new_layer.title = layer_title
			planet_layers.append(new_layer)

	ui_manager.add_layer_control(new_layer, layer_type, layer_title)
	layers.append(new_layer)


func duplicate_layer(source_layer : GeneratorLayer) -> void:
	if source_layer is StarLayer:
		duplicate_star_layer(source_layer)
		return
	elif source_layer is NebulaLayer:
		duplicate_nebula_layer(source_layer)
		return
	elif source_layer is PlanetLayer:
		duplicate_planet_layer(source_layer)
		return
	push_error("Error: no method defined to duplicate provided layer")


func duplicate_star_layer(source_layer : StarLayer) -> void:
	var new_layer : StarLayer = STAR_LAYER_RESOURCE.instantiate()
	layer_container.add_child(new_layer)

	new_layer.generate_stars\
			(source_layer.max_stars, source_layer.ratio, export_resolution)
	new_layer.title = "%s Copy" % source_layer.title
	new_layer.speed = source_layer.speed

	ui_manager.add_layer_control\
			(new_layer, LayerTypes.STAR_LAYER, new_layer.title)
	layers.append(new_layer)


func duplicate_nebula_layer(source_layer : NebulaLayer) -> void:
	var new_layer : NebulaLayer = NEBULA_LAYER_RESOURCE.instantiate()
	layer_container.add_child(new_layer)

	new_layer.set_palette(source_layer.palette)
	new_layer.set_threshold(source_layer.threshold)
	new_layer.set_density(source_layer.density)
	new_layer.set_alpha(source_layer.alpha)
	new_layer.set_dither_enabled(source_layer.dither_enabled)
	new_layer.set_modulation_enabled(source_layer.modulation_enabled)
	new_layer.set_modulation_color(source_layer.modulation_color)
	new_layer.set_modulation_intensity(source_layer.modulation_intensity)
	new_layer.set_modulation_alpha_intensity\
			(source_layer.modulation_alpha_intensity)
	new_layer.set_modulation_density(source_layer.modulation_density)
	new_layer.set_modulation_steps(source_layer.modulation_steps)
	new_layer.set_oscillate(source_layer.oscillate)
	new_layer.set_oscillation_intensity(source_layer.oscillation_intensity)
	new_layer.set_oscillation_rate(source_layer.oscillation_rate)
	new_layer.set_oscillation_offset(source_layer.oscillation_offset)
	new_layer.title = "%s Copy" % source_layer.title
	new_layer.resolution = source_layer.resolution
	new_layer.speed = source_layer.speed

	new_layer.build_nebula(export_resolution)
	new_layer.noise_texture.noise.seed = source_layer.noise_texture.noise.seed

	ui_manager.add_layer_control\
			(new_layer, LayerTypes.NEBULA_LAYER, new_layer.title)
	layers.append(new_layer)
	nebula_layers.append(new_layer)


func duplicate_planet_layer(source_layer : PlanetLayer) -> void:
	var new_layer : PlanetLayer = PLANET_LAYER_RESOURCE.instantiate()
	layer_container.add_child(new_layer)

	new_layer.resolution = export_resolution
	new_layer.max_concurrent_planets = source_layer.max_concurrent_planets
	new_layer.min_spawn_frequency = source_layer.min_spawn_frequency
	new_layer.max_spawn_frequency = source_layer.max_spawn_frequency

	# TODO: add a control for the layer to the UI manager
	layers.append(new_layer)
	planet_layers.append(new_layer)


func reorder_layer(layer : GeneratorLayer, direction : int) -> void:
	layer_container.move_child(layer, layer.get_index() + direction)


func load_preset(preset_data : Dictionary) -> void:
	for layer : Node in layer_container.get_children():
		layer.queue_free()
	ui_manager.delete_all_layer_controls()

	var new_layers : Array[GeneratorLayer] = \
			PresetUtiltity.decode_preset(preset_data)

	var ordered_new_layers : Array[GeneratorLayer] = []
	for i : int in new_layers.size(): ordered_new_layers.append(null)
	for layer: GeneratorLayer in new_layers:
		ordered_new_layers[layer.index] = layer

	for layer : GeneratorLayer in ordered_new_layers:
		layers.append(layer)
		layer_container.add_child(layer)
		if layer is StarLayer:
			layer.generate_stars\
					(layer.max_stars, layer.ratio.duplicate(),
					export_resolution)
			ui_manager.add_layer_control\
					(layer, LayerTypes.STAR_LAYER, layer.title)
		elif layer is NebulaLayer:
			ui_manager.add_layer_control\
					(layer, LayerTypes.NEBULA_LAYER, layer.title)
			layer.build_nebula(export_resolution)
		elif layer is PlanetLayer:
			ui_manager.add_layer_control\
					(layer, LayerTypes.PLANET_LAYER, layer.title)


func upload_preset() -> void:
	var preset_data : Dictionary = await JavaScriptUtility.load_preset()
	ui_manager.preset_manager.add_preset_button(preset_data)


func evaluate_export_request(export_type : ExportTypes) -> void:
	match export_type:
		ExportTypes.PNG:
			export_as_png()
		ExportTypes.PRESET:
			export_as_preset()


func export_as_png() -> void:
	for layer : GeneratorLayer in layers:
		if layer is PlanetLayer: continue
		JavaScriptUtility.save_image(layer.texture.get_image(), layer.title)


func export_as_packed_scene() -> void:
	pass


func export_as_preset() -> void:
	JavaScriptUtility.save_preset\
			(PresetUtiltity.generate_preset(layer_container.get_children()))


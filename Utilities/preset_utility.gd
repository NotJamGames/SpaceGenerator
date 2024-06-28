class_name PresetUtiltity
extends Node


const STAR_LAYER_RESOURCE : Resource = \
		preload("res://GeneratorLayers/StarLayer/star_layer.tscn")
const NEBULA_LAYER_RESOURCE : Resource = \
		preload("res://GeneratorLayers/NebulaLayer/nebula_layer.tscn")
const PLANET_LAYER_RESOURCE : Resource = \
		preload("res://GeneratorLayers/PlanetLayer/planet_layer.tscn")


static func generate_preset(layers : Array[Node]) -> Dictionary:
	#TODO: add a global settings section, resolution audio etc.
	var preset_contents : Dictionary = {}

	var unique_id : int = -1

	for i in layers.size():
		var layer : Node = layers[i]

		# TODO: get the user defined name, rather than just generating one
		# ensure that each layer name is unique! otherwise we'll overwrite
		# layers with matching names
		unique_id += 1

		if layer is StarLayer:
			preset_contents["StarLayer%s" % unique_id] \
					= encode_star_layer(layer, i)
		elif layer is NebulaLayer:
			preset_contents["NebulaLayer%s" % unique_id] \
					= encode_nebula_layer(layer, i)
		elif layer is PlanetLayer:
			preset_contents["PlanetLayer%s" % unique_id] \
					= encode_planet_layer(layer, i)
	return preset_contents


static func decode_preset(preset_data : Dictionary) -> Array[GeneratorLayer]:
	#TODO: add a global settings section, resolution audio etc.
	var new_layers : Array[GeneratorLayer] = []
	for key in preset_data:
		if key.begins_with("StarLayer"):
			new_layers.append(decode_star_layer(preset_data[key]))
		if key.begins_with("NebulaLayer"):
			new_layers.append(decode_nebula_layer(preset_data[key]))
		if key.begins_with("PlanetLayer"):
			new_layers.append(decode_planet_layer(preset_data[key]))
	return new_layers


static func encode_star_layer(layer : StarLayer, index : int) -> Dictionary:
	var star_layer_data : Dictionary = {}
	star_layer_data["index"] = index
	star_layer_data["max_stars"] = layer.max_stars
	star_layer_data["ratio"] = layer.ratio
	star_layer_data["title"] = layer.title
	star_layer_data["resolution"] = layer.resolution
	star_layer_data["speed"] = layer.speed
	return star_layer_data


static func decode_star_layer(layer_data : Dictionary) -> StarLayer:
	var new_star_layer : StarLayer = STAR_LAYER_RESOURCE.instantiate()
	new_star_layer.index = layer_data["index"]
	new_star_layer.max_stars = layer_data["max_stars"]
	new_star_layer.ratio = layer_data["ratio"]
	new_star_layer.title = layer_data["title"]
	new_star_layer.resolution = TypeConversionUtility.string_to_vector2i\
			(layer_data["resolution"])
	new_star_layer.speed = layer_data["speed"]
	return new_star_layer


static func encode_nebula_layer(layer : NebulaLayer, index : int) -> Dictionary:
	var nebula_layer_data : Dictionary = {}
	nebula_layer_data.index = index
	nebula_layer_data["seed"] = layer.noise_texture.noise.seed

	var palette_data : PackedByteArray = \
			layer.palette.get_image().save_png_to_buffer()
	var palette_data_base_64 : String = Marshalls.raw_to_base64(palette_data)
	nebula_layer_data["palette"] = palette_data_base_64

	nebula_layer_data["threshold"] = layer.threshold
	nebula_layer_data["density"] = layer.density
	nebula_layer_data["alpha"] = layer.alpha
	nebula_layer_data["dither_enabled"] = layer.dither_enabled
	nebula_layer_data["modulation_seed"] = \
			layer.modulation_noise_texture.noise.seed
	nebula_layer_data["modulation_enabled"] = layer.modulation_enabled
	nebula_layer_data["modulation_color"] = layer.modulation_color.to_html()
	nebula_layer_data["modulation_intensity"] = layer.modulation_intensity
	nebula_layer_data["modulation_alpha_intensity"] = \
			layer.modulation_alpha_intensity
	nebula_layer_data["modulation_density"] = layer.modulation_density
	nebula_layer_data["modulation_steps"] = layer.modulation_steps
	nebula_layer_data["oscillate"] = layer.oscillate
	nebula_layer_data["oscillation_intensity"] = layer.oscillation_intensity
	nebula_layer_data["oscillation_rate"] = layer.oscillation_rate
	nebula_layer_data["oscillation_offset"] = layer.oscillation_offset
	nebula_layer_data["title"] = layer.title
	nebula_layer_data["resolution"] = layer.resolution
	nebula_layer_data["speed"] = layer.speed
	return nebula_layer_data


static func decode_nebula_layer(layer_data : Dictionary) -> NebulaLayer:
	var new_nebula_layer : NebulaLayer = NEBULA_LAYER_RESOURCE.instantiate()
	new_nebula_layer.index = layer_data["index"]
	new_nebula_layer.nebula_seed = layer_data["seed"]

	var palette_data : PackedByteArray = \
			Marshalls.base64_to_raw(layer_data["palette"])
	var palette_image : Image = Image.new()
	palette_image.load_png_from_buffer(palette_data)
	new_nebula_layer.palette = ImageTexture.create_from_image(palette_image)

	new_nebula_layer.threshold = layer_data["threshold"]
	new_nebula_layer.density = layer_data["density"]
	new_nebula_layer.alpha = layer_data["alpha"]
	new_nebula_layer.dither_enabled = layer_data["dither_enabled"]

	new_nebula_layer.modulation_seed = layer_data["modulation_seed"]
	new_nebula_layer.modulation_enabled = layer_data["modulation_enabled"]
	new_nebula_layer.modulation_color = Color(layer_data["modulation_color"])
	new_nebula_layer.modulation_intensity = layer_data["modulation_intensity"]
	new_nebula_layer.modulation_alpha_intensity = \
			layer_data["modulation_alpha_intensity"]
	new_nebula_layer.modulation_density = layer_data["modulation_density"]
	new_nebula_layer.modulation_steps = layer_data["modulation_steps"]

	new_nebula_layer.oscillate = layer_data["oscillate"]
	new_nebula_layer.oscillation_intensity = \
			layer_data["oscillation_intensity"]
	new_nebula_layer.oscillation_rate = layer_data["oscillation_rate"]
	new_nebula_layer.oscillation_offset = layer_data["oscillation_offset"]
	new_nebula_layer.title = layer_data["title"]
	new_nebula_layer.resolution = TypeConversionUtility.string_to_vector2i\
			(layer_data["resolution"])
	new_nebula_layer.speed = layer_data["speed"]
	return new_nebula_layer


static func encode_planet_layer(layer : PlanetLayer, index : int) -> Dictionary:
	var planet_layer_data : Dictionary = {}
	planet_layer_data["index"] = index
	planet_layer_data["min_spawn_frequency"] = layer.min_spawn_frequency
	planet_layer_data["max_spawn_frequency"] = layer.max_spawn_frequency
	planet_layer_data["max_concurrent_planets"] = layer.max_concurrent_planets
	planet_layer_data["title"] = layer.title
	planet_layer_data["resolution"] = layer.resolution
	planet_layer_data["speed"] = layer.speed
	return planet_layer_data


static func decode_planet_layer(layer_data : Dictionary) -> PlanetLayer:
	var new_planet_layer : PlanetLayer = PLANET_LAYER_RESOURCE.instantiate()
	new_planet_layer.index = layer_data["index"]
	new_planet_layer.min_spawn_frequency = layer_data["min_spawn_frequency"]
	new_planet_layer.max_spawn_frequency = layer_data["max_spawn_frequency"]
	new_planet_layer.max_concurrent_planets = \
			layer_data["max_concurrent_planets"]
	# TODO: fix!
	new_planet_layer.title = layer_data["title"]
	new_planet_layer.resolution = TypeConversionUtility.string_to_vector2i\
			(layer_data["resolution"])
	new_planet_layer.speed = layer_data["speed"]
	return new_planet_layer

class_name PresetUtiltity
extends Node


const STAR_LAYER_RESOURCE : Resource = \
		preload("res://GeneratorLayers/StarLayer/star_layer.tscn")
const NEBULA_LAYER_RESOURCE : Resource = \
		preload("res://GeneratorLayers/NebulaLayer/nebula_layer.tscn")
const PLANET_LAYER_RESOURCE : Resource = \
		preload("res://GeneratorLayers/PlanetLayer/planet_layer.tscn")


static func generate_preset(layers : Array[Node]) -> Dictionary:
	var preset_contents : Dictionary = {}

	var unique_id : int = -1

	for layer in layers:
		# TODO: get the user defined name, rather than just generating one
		# ensure that each layer name is unique! otherwise we'll overwrite
		# layers with matching names
		unique_id += 1

		if layer is StarLayer:
			preset_contents["StarLayer%s" % unique_id] \
					= encode_star_layer(layer)
		elif layer is NebulaLayer:
			preset_contents["NebulaLayer%s" % unique_id] \
					= encode_nebula_layer(layer)
		elif layer is PlanetLayer:
			preset_contents["PlanetLayer%s" % unique_id] \
					= encode_planet_layer(layer)
	return preset_contents


static func decode_preset(preset_data : Dictionary) -> Array[GeneratorLayer]:
	var new_layers : Array[GeneratorLayer] = []
	for key in preset_data:
		if key.begins_with("StarLayer"):
			new_layers.append(decode_star_layer(preset_data[key]))
	return new_layers


static func encode_star_layer(layer : StarLayer) -> Dictionary:
	var star_layer_data : Dictionary = {}
	star_layer_data["max_stars"] = layer.max_stars
	star_layer_data["ratio"] = layer.ratio
	star_layer_data["speed"] = layer.speed
	return star_layer_data


static func decode_star_layer(layer_data : Dictionary) -> StarLayer:
	var new_star_layer : StarLayer = STAR_LAYER_RESOURCE.instantiate()
	new_star_layer.max_stars = layer_data["max_stars"]
	new_star_layer.ratio = layer_data["ratio"]
	new_star_layer.speed = layer_data["speed"]
	return new_star_layer


static func encode_nebula_layer(layer : NebulaLayer) -> Dictionary:
	var nebula_layer_data : Dictionary = {}
	nebula_layer_data["seed"] = layer.noise_texture.noise.seed
	nebula_layer_data["palette"] = \
			layer.palette.get_image().save_png_to_buffer()
	nebula_layer_data["threshold"] = layer.threshold
	nebula_layer_data["density"] = layer.density
	nebula_layer_data["alpha"] = layer.alpha
	nebula_layer_data["dither_enabled"] = layer.dither_enabled
	nebula_layer_data["modulation_seed"] = \
			layer.modulation_noise_texture.noise.seed
	nebula_layer_data["modulation_enabled"] = layer.modulation_enabled
	nebula_layer_data["modulation_color"] = layer.modulation_color
	nebula_layer_data["modulation_intensity"] = layer.modulation_intensity
	nebula_layer_data["modulation_alpha_intensity"] = \
			layer.modulation_alpha_intensity
	nebula_layer_data["modulation_density"] = layer.modulation_density
	nebula_layer_data["modulation_steps"] = layer.modulation_steps
	nebula_layer_data["oscillate"] = layer.oscillate
	nebula_layer_data["oscillation_intensity"] = layer.oscillation_intensity
	nebula_layer_data["oscillation_rate"] = layer.oscillation_rate
	nebula_layer_data["oscillation_offset"] = layer.oscillation_offset
	nebula_layer_data["speed"] = layer.speed
	return nebula_layer_data


static func decode_nebula_layer(layer_data : Dictionary) -> NebulaLayer:
	return null


static func encode_planet_layer(layer : PlanetLayer) -> Dictionary:
	var planet_layer_data : Dictionary = {}
	planet_layer_data["min_spawn_frequency"] = layer.min_spawn_frequency
	planet_layer_data["max_spawn_frequency"] = layer.max_spawn_frequency
	planet_layer_data["max_concurrent_planets"] = layer.max_concurrent_planets
	planet_layer_data["speed"] = layer.speed
	return planet_layer_data


static func decode_planet_layer(layer_data : Dictionary) -> PlanetLayer:
	return null

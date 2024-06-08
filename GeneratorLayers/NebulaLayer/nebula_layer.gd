@tool
class_name NebulaLayer
extends GeneratorLayer


@export_category("Node Paths")
@export var subviewport : SubViewport
@export var sprite : Sprite2D


const nebula_dither_shader : Shader = preload\
		("res://GeneratorLayers/NebulaLayer/nebula_shader.gdshader")


@export_category("Nebula Parameters")
@export var palette : Texture : set = set_palette
@export_range(.0, 1.0) var threshold : float = .0 : set = set_threshold
@export_range(.0, 1.0) var alpha : float = 1.0 : set = set_alpha
@export var dither_enabled : bool = true : set = set_dither_enabled

@export var oscillate : bool = false : set = set_oscillate
@export_range(.0, 2.0) var oscillation_intensity : float = .24 :\
		set = set_oscillation_intensity
@export_range(.01, 16.0) var oscillation_rate : float = .2 :\
		set = set_oscillation_rate
@export_range(.0, .5) var oscillation_offset : float = .0 :\
		set = set_oscillation_offset


@onready var noise_texture : NoiseTexture2D = NoiseTexture2D.new()
@onready var shader_material : ShaderMaterial = ShaderMaterial.new()


func _ready() -> void:
	shader_material.shader = nebula_dither_shader
	sprite.material = shader_material

	set_threshold(threshold)
	set_alpha(alpha)
	set_oscillate(oscillate)
	set_oscillation_intensity(oscillation_intensity)
	set_oscillation_rate(oscillation_rate)
	set_oscillation_offset(oscillation_offset)


func build_nebula(new_base_size : Vector2i) -> void:
	subviewport.size = new_base_size

	noise_texture.seamless = true
	noise_texture.width = new_base_size.x
	noise_texture.height = new_base_size.y

	set_palette(palette)

	var noise : FastNoiseLite = FastNoiseLite.new()
	noise.seed = randi()
	noise_texture.noise = noise

	sprite.texture = noise_texture
	sprite.centered = false


func set_palette(new_palette : Texture) -> void:
	palette = new_palette
	if noise_texture == null or shader_material == null: return

	shader_material.set_shader_parameter("palette", palette)


func set_shader_parameter(param_name : String, value : Variant) -> void:
	if shader_material == null: return
	shader_material.set_shader_parameter(param_name, value)


func set_threshold(new_threshold : float) -> void:
	threshold = new_threshold
	set_shader_parameter("threshold", threshold)


func set_alpha(new_alpha : float) -> void:
	alpha = new_alpha
	set_shader_parameter("alpha", alpha)


func set_dither_enabled(new_state : bool) -> void:
	dither_enabled = new_state
	set_shader_parameter("dither_enabled", dither_enabled)


func set_oscillate(new_state : bool) -> void:
	oscillate = new_state
	set_shader_parameter("oscillate", oscillate)


func set_oscillation_intensity(value : float) -> void:
	oscillation_intensity = value
	set_shader_parameter("oscillation_intensity", oscillation_intensity)


func set_oscillation_rate(value : float) -> void:
	oscillation_rate = value
	set_shader_parameter("oscillation_rate", value)


func set_oscillation_offset(value : float) -> void:
	oscillation_offset = value
	set_shader_parameter("oscillation_offset", value)


func new_seed() -> void:
	noise_texture.noise.seed = randi()

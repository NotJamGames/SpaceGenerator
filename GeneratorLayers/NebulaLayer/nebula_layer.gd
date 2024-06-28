@tool
class_name NebulaLayer
extends GeneratorLayer


@export_category("Node Paths")
@export var subviewport : SubViewport
@export var sprite : Sprite2D


const nebula_dither_shader : Shader = preload\
		("res://GeneratorLayers/NebulaLayer/nebula_shader.gdshader")

@export_category("Nebula Parameters")
@export var nebula_seed : int = -1
@export var palette : Texture : set = set_palette
@export_range(.0, 1.0) var threshold : float = .0 : set = set_threshold
@export_range(.0, 1.0) var density : float = .01 : set = set_density
@export_range(.0, 1.0) var alpha : float = 1.0 : set = set_alpha
@export var dither_enabled : bool = true : set = set_dither_enabled

@export var modulation_seed : int = -1
@export var modulation_enabled : bool = false : set = set_modulation_enabled
@export var modulation_color : Color = Color.WHITE : set = set_modulation_color
@export_range(.0, 1.0) var modulation_intensity : float = .5 :\
		set = set_modulation_intensity
@export_range(.0, 1.0) var modulation_alpha_intensity : float = .0 :\
		set = set_modulation_alpha_intensity
@export_range(.0, 1.0) var modulation_density : float = .01 :\
		set = set_modulation_density
@export_range(2, 16) var modulation_steps : int = 4 : set = set_modulation_steps

@export var oscillate : bool = false : set = set_oscillate
@export_range(.0, 2.0) var oscillation_intensity : float = .24 :\
		set = set_oscillation_intensity
@export_range(.01, 16.0) var oscillation_rate : float = .2 :\
		set = set_oscillation_rate
@export_range(.0, .5) var oscillation_offset : float = .0 :\
		set = set_oscillation_offset


@onready var noise_texture : NoiseTexture2D = NoiseTexture2D.new()
@onready var modulation_noise_texture : NoiseTexture2D = NoiseTexture2D.new()
@onready var shader_material : ShaderMaterial = ShaderMaterial.new()


func _ready() -> void:
	shader_material.shader = nebula_dither_shader
	sprite.material = shader_material

	set_threshold(threshold)
	set_density(density)
	set_alpha(alpha)
	set_dither_enabled(dither_enabled)
	set_modulation_enabled(modulation_enabled)
	set_modulation_color(modulation_color)
	set_modulation_intensity(modulation_intensity)
	set_modulation_alpha_intensity(modulation_alpha_intensity)
	set_modulation_density(modulation_density)
	set_modulation_steps(modulation_steps)
	set_oscillate(oscillate)
	set_oscillation_intensity(oscillation_intensity)
	set_oscillation_rate(oscillation_rate)
	set_oscillation_offset(oscillation_offset)

	if !resolution == Vector2i.ZERO:
		build_nebula(resolution)


func build_nebula(new_base_size : Vector2i) -> void:
	subviewport.size = new_base_size

	noise_texture.seamless = true
	noise_texture.width = new_base_size.x
	noise_texture.height = new_base_size.y

	set_palette(palette)

	var noise : FastNoiseLite = FastNoiseLite.new()
	noise.seed = randi() if nebula_seed == -1 else nebula_seed
	noise.frequency = density
	noise_texture.noise = noise

	sprite.texture = noise_texture
	sprite.centered = false

	modulation_noise_texture = NoiseTexture2D.new()
	modulation_noise_texture.width = new_base_size.x
	modulation_noise_texture.height = new_base_size.y
	modulation_noise_texture.seamless = true
	modulation_noise_texture.noise = FastNoiseLite.new()
	modulation_noise_texture.noise.seed = randi() if modulation_seed == -1 \
			else modulation_seed
	modulation_noise_texture.noise.frequency = modulation_density
	set_shader_parameter\
			("modulation_noise_texture", modulation_noise_texture)

	resolution = new_base_size


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


func set_density(new_value : float) -> void:
	density = new_value
	if noise_texture == null: return
	if noise_texture.noise != null:
		noise_texture.noise.frequency = new_value


func set_alpha(new_alpha : float) -> void:
	alpha = new_alpha
	set_shader_parameter("alpha", alpha)


func set_dither_enabled(new_state : bool) -> void:
	dither_enabled = new_state
	set_shader_parameter("dither_enabled", dither_enabled)


func set_modulation_enabled(new_state : bool) -> void:
	modulation_enabled = new_state
	set_shader_parameter("modulation_enabled", modulation_enabled)


func set_modulation_color(new_color : Color) -> void:
	modulation_color = new_color
	set_shader_parameter("modulation_color", modulation_color)


func set_modulation_intensity(new_value : float) -> void:
	modulation_intensity = new_value
	set_shader_parameter("modulation_intensity", modulation_intensity)


func set_modulation_alpha_intensity(new_value : float) -> void:
	modulation_alpha_intensity = new_value
	set_shader_parameter\
			("modulation_alpha_intensity", modulation_alpha_intensity)


func set_modulation_density(new_value : float) -> void:
	modulation_density = new_value
	if modulation_noise_texture == null: return
	if modulation_noise_texture.noise != null:
		modulation_noise_texture.noise.frequency = new_value


func set_modulation_steps(new_value : int) -> void:
	new_value = clampi(new_value, 2, 16)
	modulation_steps = new_value
	set_shader_parameter("modulation_steps", float(modulation_steps))


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
	modulation_noise_texture.noise.seed = randi()

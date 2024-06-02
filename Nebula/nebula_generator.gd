@tool
class_name NebulaLayer
extends GeneratorLayer


@export_category("Node Paths")
@export var subviewport : SubViewport
@export var sprite : Sprite2D


const nebula_dither_shader : Shader = preload\
		("res://Nebula/nebula_dither_shader.gdshader")


@export_category("Nebula Parameters")
@export var palette : Texture : set = set_palette
@export var contrast : float = 1.0 : set = set_contrast
@export var threshold : float = 1.0 : set = set_threshold
@export var alpha : float = 1.0 : set = set_alpha


@onready var noise_texture : NoiseTexture2D = NoiseTexture2D.new()
@onready var shader_material : ShaderMaterial = ShaderMaterial.new()


func _ready() -> void:
	shader_material.shader = nebula_dither_shader
	sprite.material = shader_material
	set_contrast(contrast)
	set_threshold(threshold)
	set_alpha(alpha)


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

	var new_gradient : Gradient = Gradient.new()
	new_gradient.add_point(.0, Color(.0, .0, .0, .0))

	var palette_width : int = palette.get_width()
	var palette_image : Image = palette.get_image()
	for i : int in palette_width:
		new_gradient.add_point\
				(.36 + ((i + .5) * (.64 / palette_width)),
				palette_image.get_pixel(i, 0))

	noise_texture.color_ramp = new_gradient

	shader_material.set_shader_parameter("palette", palette)


func set_contrast(new_contrast : float) -> void:
	contrast = new_contrast
	if shader_material == null: return
	shader_material.set_shader_parameter("contrast", contrast)


func set_threshold(new_threshold : float) -> void:
	threshold = new_threshold
	if shader_material == null: return
	shader_material.set_shader_parameter("threshold", threshold)


func set_alpha(new_alpha) -> void:
	alpha = new_alpha
	if shader_material == null: return
	shader_material.set_shader_parameter("alpha", alpha)

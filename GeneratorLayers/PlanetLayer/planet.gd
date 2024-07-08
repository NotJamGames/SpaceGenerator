class_name Planet
extends Sprite2D


const PLANET_TEXTURE_RESOURCES : Array[Texture] = \
[
	preload("res://GeneratorLayers/PlanetLayer/Sprites/large_planet_1.png"),
	preload("res://GeneratorLayers/PlanetLayer/Sprites/large_planet_2.png"),
	preload("res://GeneratorLayers/PlanetLayer/Sprites/large_planet_3.png"),
	preload("res://GeneratorLayers/PlanetLayer/Sprites/small_planet_1.png"),
	preload("res://GeneratorLayers/PlanetLayer/Sprites/small_planet_2.png"),
	preload("res://GeneratorLayers/PlanetLayer/Sprites/small_planet_3.png"),
	preload("res://GeneratorLayers/PlanetLayer/Sprites/small_planet_6.png")
]

var export_resolution : Vector2i
var speed : float
var enabled : bool = false

signal was_enabled()
signal was_disabled()


func _process(delta : float) -> void:
	if !enabled: return

	position.y += delta * speed
	if position.y > export_resolution.y * 2:
		enabled = false
		was_disabled.emit(-1)


func respawn() -> void:
	texture = PLANET_TEXTURE_RESOURCES\
			[randi_range(0, PLANET_TEXTURE_RESOURCES.size() - 1)]
	position = Vector2i\
			(randi_range(1, export_resolution.x - texture.get_width() - 1) * 2,
			- texture.get_height() * 2)
	enabled = true

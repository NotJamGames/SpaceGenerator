class_name PlanetLayer
extends GeneratorLayer


var planets : Array[Planet] = []
var curr_planet_index : int = 0
var distance_since_spawn : float = .0
var distance_to_next_spawn : float


@export var min_spawn_frequency : float = 64.0
@export var max_spawn_frequency : float = 512.0
@export var max_concurrent_planets : int = 3 : set = set_max_concurrent_planets


func _ready() -> void:
	instantiate_planets(9)
	check_respawn()


func _process(delta : float) -> void:
	distance_since_spawn += delta * speed
	if distance_since_spawn > distance_to_next_spawn: check_respawn()


func set_max_concurrent_planets(new_value : int) -> void:
	max_concurrent_planets = new_value
	curr_planet_index = wrapi(curr_planet_index, 0, new_value)


func set_speed(new_value : float) -> void:
	speed = new_value
	for planet : Planet in planets:
		planet.speed = new_value


func check_respawn() -> void:
	if !planets[curr_planet_index].enabled:
		planets[curr_planet_index].respawn()

	curr_planet_index = wrapi\
			(curr_planet_index + 1, 0, max_concurrent_planets)

	distance_since_spawn = .0
	distance_to_next_spawn = randf_range\
			(min_spawn_frequency, max_spawn_frequency)


func instantiate_planets(num_planets : int) -> void:
	for i : int in num_planets:
		var new_planet : Planet = Planet.new()
		new_planet.centered = false
		new_planet.scale = Vector2i(2, 2)
		new_planet.speed = speed
		new_planet.export_resolution = resolution
		new_planet.position = Vector2i(-1920, -1080) # safely offscreen
		add_child(new_planet)
		planets.append(new_planet)

class_name PlanetLayer
extends GeneratorLayer


var active_planets : Array[Planet] = []
var curr_planet_index : int = 0
var export_resolution : Vector2i = Vector2i(360, 240)


@export var min_spawn_frequency : float = 9.0
@export var max_spawn_frequency : float = 18.0
@export var max_concurrent_planets : int = 2 : set = set_max_concurrent_planets

@export var num_enabled_planets : int = 0


func _ready() -> void:
	instantiate_planets(max_concurrent_planets)
	check_respawn()


func _process(_delta : float) -> void:
	# we override this here as we'll be moving planets individually 
	# and resetting their positions once they exit screen space
	pass


func set_export_resolution(new_resolution : Vector2i) -> void:
	export_resolution = new_resolution


func set_max_concurrent_planets(new_value : int) -> void:
	var planet_diff : int = new_value - max_concurrent_planets
	max_concurrent_planets = new_value

	if planet_diff > 0:
		instantiate_planets(planet_diff)
	elif planet_diff < 0:
		free_planets(abs(planet_diff))


func set_speed(new_value : float) -> void:
	speed = new_value
	for planet : Planet in active_planets:
		planet.speed = new_value


func increment_num_enabled_planets(mod : int) -> void:
	num_enabled_planets += mod


func check_respawn() -> void:
	var timer : SceneTreeTimer = get_tree().create_timer\
			(randf_range(min_spawn_frequency, max_spawn_frequency))
	timer.timeout.connect(check_respawn)

	if num_enabled_planets < max_concurrent_planets:
		active_planets[curr_planet_index].respawn()
		curr_planet_index = wrapi\
				(curr_planet_index + 1, 0, active_planets.size())


func instantiate_planets(num_planets : int) -> void:
	for i : int in num_planets:
		var new_planet : Planet = Planet.new()
		new_planet.centered = false
		new_planet.scale = Vector2i(2, 2)
		new_planet.speed = speed
		new_planet.export_resolution = export_resolution
		new_planet.position = Vector2i(-1920, -1080) # safely offscreen
		new_planet.was_enabled.connect(increment_num_enabled_planets)
		new_planet.was_disabled.connect(increment_num_enabled_planets)
		add_child(new_planet)
		active_planets.append(new_planet)


func free_planets(num_planets : int) -> void:
	# if this check is ever true we have an issue
	# but let's be safe anyway
	if active_planets.size() > num_planets:
		push_warning("Warning: attempting to free more planets than currently instantiated - check UI settings")
		num_planets = active_planets.size()

	for i : int in num_planets:
		var free_planet : Sprite2D = active_planets.pop_back()
		if free_planet.enabled:
			increment_num_enabled_planets(- 1)
		free_planet.queue_free()

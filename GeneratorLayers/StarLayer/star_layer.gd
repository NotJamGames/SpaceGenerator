class_name StarLayer
extends GeneratorLayer


const MARGIN : float = 3.0


const SMALL_STAR_RESOURCES : Array[Resource] = \
[
	preload("res://GeneratorLayers/StarLayer/Textures/small_star_1.png"),
	preload("res://GeneratorLayers/StarLayer/Textures/small_star_2.png")
]

const MEDIUM_STAR_RESOURCES : Array[Resource] = \
[
	preload("res://GeneratorLayers/StarLayer/Textures/medium_star_1.png"),
	preload("res://GeneratorLayers/StarLayer/Textures/medium_star_2.png"),
	preload("res://GeneratorLayers/StarLayer/Textures/medium_star_3.png")
]

const LARGE_STAR_RESOURCES : Array[Resource] = \
[
	preload("res://GeneratorLayers/StarLayer/Textures/large_star.png")
]

@onready var star_resources : Array[Array] = \
			[SMALL_STAR_RESOURCES, MEDIUM_STAR_RESOURCES, LARGE_STAR_RESOURCES]


@export var root_2d : Node2D


func generate_stars\
		(max_stars : int, ratio : Array[float], viewport_size : Vector2)\
		-> void:
	clear_stars()

	var ratio_sum : float = ratio.reduce\
	(
		func(accum : float, number : float) -> float: return accum + number,
		.0
	)

	for i : int in max_stars:
		var new_seed : float = randf_range(.0, ratio_sum)
		var new_star_id : int = 0

		for f : float in ratio:
			if new_seed <= f:
				break
			new_seed -= f
			new_star_id += 1

		var new_star_sprite : Sprite2D = Sprite2D.new()
		new_star_sprite.centered = false
		new_star_sprite.position = Vector2\
				(randf_range(.0 + MARGIN, viewport_size.x - MARGIN),
				randf_range(.0 + MARGIN, viewport_size.y - MARGIN)).floor()

		var poss_textures = star_resources[new_star_id]
		new_star_sprite.texture = \
				poss_textures[randi_range(0, poss_textures.size() - 1)]

		root_2d.add_child(new_star_sprite)


func clear_stars() -> void:
	for i : Node in root_2d.get_children():
		i.queue_free()

class_name TypeConversionUtility
extends Node


static func string_to_vector2i(string : String) -> Vector2i:
	string = string.lstrip("(").rstrip(")")
	var vector_data : Array = string.split(", ")
	for i : Variant in vector_data.size():
		var vector_component : int = vector_data[i] as int
		if vector_component == null:
			push_error("Error: string cannot be converted to Vector2i")
			return Vector2i.ZERO
		vector_data[i] = vector_component

	return Vector2i(vector_data[0], vector_data[1])

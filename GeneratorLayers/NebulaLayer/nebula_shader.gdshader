shader_type canvas_item;

uniform sampler2D palette : filter_nearest;

uniform float threshold : hint_range(.0, 1.0, .01) = .0;
uniform float alpha : hint_range(.0, 1.0, .01) = 1.0;
uniform bool dither_enabled = true;

uniform bool oscillate = false;
uniform float oscillation_intensity : hint_range(.01, 1.0, .01) = .12;
uniform float oscillation_rate : hint_range(.01, 4.0, .01) = .2;
uniform float oscillation_offset : hint_range(.0, .5, .01) = .0;

const int bayer_matrix[16] = int[](0,  8,  2,  10,
                                     12, 4,  14, 6,
                                     3,  11, 1,  9,
                                     15, 7,  13, 5);

float index_value(vec4 fragcoord)
{
	ivec2 matrix_pos = ivec2
			(int(mod(fragcoord.x, 4)), int(mod(fragcoord.y, 4)));
	return float(bayer_matrix[(matrix_pos.x + matrix_pos.y * 4)]) / 16.0;
}


vec4[2] closest_color(float lum, vec4 color)
{
	float color_size = 1.0 / float(textureSize(palette, 0).x);

	float high = min(1.0, lum + color_size);

	if (lum < .0 && high < .0)
	{
		return vec4[2]
		(vec4(.0, .0, .0, .0), vec4(.0, .0, .0, .0));
	}
	else if (lum < .0)
	{
		return vec4[2]
		(vec4(.0, .0, .0, .0),
		texture(palette, vec2(high, .0)));
	}
	else
	{
		return vec4[2]
		(texture(palette, vec2(lum, .0)),
		texture(palette, vec2(high, .0)));
	}
}


vec4 dither(vec4 color, vec4 fragcoord)
{
	float new_threshold = threshold;
	if (oscillate)
	{
		new_threshold = (sin((TIME + oscillation_offset) * oscillation_rate) 
		* oscillation_intensity) + threshold;
	}

	float lum = 
		(color.r * 0.299) + (color.g * 0.587) + (color.b * 0.114)
		- new_threshold;
	vec4 colors[2] = closest_color(lum, fragcoord);
	if (!dither_enabled){return colors[0];}

	float matrix_value = index_value(fragcoord);
	return lum < matrix_value ? colors[0] : colors[1];
}


void fragment()
{
	vec4 new_color = vec4(dither(COLOR, FRAGCOORD));
	new_color.a *= alpha;
	COLOR = new_color;
}
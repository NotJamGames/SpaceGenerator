shader_type canvas_item;

uniform sampler2D palette : filter_nearest;

uniform float contrast;
uniform float brightness;
uniform float alpha = 1.0;

const int indexMatrix4x4[16] = int[](0,  8,  2,  10,
                                     12, 4,  14, 6,
                                     3,  11, 1,  9,
                                     15, 7,  13, 5);

float index_value(vec4 fragcoord)
{
	int x = int(mod(fragcoord.x, 4));
	int y = int(mod(fragcoord.y, 4));
	return float(indexMatrix4x4[(x + y * 4)]) / 16.0;
}


vec4[2] closest_color(float lum, vec4 color)
{
	// the lowest value of our palette is always transparent
	// so first, we check alpha of color and if < 1
	// return the first two values of our palette
	const float EPSILON = .01;
	if (color.a < 1.0 - EPSILON)
	{
		return vec4[2] (vec4(.0, .0, .0, .0), texture(palette, vec2(0, 0)));
	}

	float palette_size = float(textureSize(palette, 0).x) - 1.0;

	// avoid wrapping around palette
	lum = max(lum - 0.00001, 0.0);
	float lum_scale = (lum * palette_size) / contrast;
	float base = floor(lum * palette_size);
	float low = base * lum_scale;
	float high = (base + 1.0) * lum_scale;

	return vec4[2]
		(texture(palette, vec2(low, .0)),
		texture(palette, vec2(high, .0)));
}


vec4 dither(vec4 color, vec4 fragcoord)
{
	float lum = 
		(color.r * 0.299) + (color.g * 0.587) + (color.b * 0.114)
		* brightness;
	vec4 colors[2] = closest_color(lum, fragcoord);

	float matrix_value = index_value(fragcoord);
	return lum < matrix_value ? colors[0] : colors[1];
}


void fragment()
{
	vec4 new_color = vec4(dither(COLOR, FRAGCOORD));
	new_color.a *= alpha * COLOR.a;
	COLOR = new_color;
}
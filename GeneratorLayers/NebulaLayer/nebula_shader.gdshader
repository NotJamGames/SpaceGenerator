shader_type canvas_item;

uniform sampler2D palette : filter_nearest;

uniform float threshold : hint_range(.0, 1.0, .01) = .0;
uniform float alpha : hint_range(.0, 1.0, .01) = 1.0;
uniform bool dither_enabled = true;

uniform sampler2D modulation_noise_texture;
uniform bool modulation_enabled;
uniform vec4 modulation_color;
uniform float modulation_intensity : hint_range(.0, 1.0, .01) = .5;
uniform float modulation_alpha_intensity : hint_range(.0, 1.0, 0.01) = .0;
uniform float modulation_steps : hint_range(1.0, 16.0, 1.0);

uniform bool oscillate = false;
uniform float oscillation_intensity : hint_range(.01, 1.0, .01) = .12;
uniform float oscillation_rate : hint_range(.01, 4.0, .01) = .2;
uniform float oscillation_offset : hint_range(.0, 1.0, .01) = .0;

const int bayer_matrix[16] = int[](0,  8,  2,  10,
                                     12, 4,  14, 6,
                                     3,  11, 1,  9,
                                     15, 7,  13, 5);


float get_luminosity(vec4 color)
{
	return (color.r * 0.299) + (color.g * 0.587) + (color.b * 0.114);
}


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


vec4 match_color(vec4 color, vec4 fragcoord)
{
	float new_threshold = threshold;
	if (oscillate)
	{
		new_threshold = (sin((TIME * oscillation_rate) + oscillation_offset)
		* oscillation_intensity) + threshold;
	}

	float luminosity = get_luminosity(color) - new_threshold;
	vec4 colors[2] = closest_color(luminosity, fragcoord);

	if (!dither_enabled){return colors[0];}

	// dither, if enabled
	float matrix_value = index_value(fragcoord);
	return luminosity < matrix_value ? colors[0] : colors[1];
}


vec4 modulate(vec4 color, vec2 fragcoord)
{
	vec4 lum_source = texture(modulation_noise_texture, fragcoord.xy);
	float luminosity = 
			floor(min(get_luminosity(lum_source), .999) * modulation_steps) 
			/ modulation_steps;
	vec4 adjusted_modulation_color = modulation_color * luminosity;
	color.a *= 1.0 - ((1.0 - luminosity) * modulation_alpha_intensity);
	adjusted_modulation_color.a = color.a;
	return mix(color, adjusted_modulation_color, modulation_intensity);
}


void fragment()
{
	vec4 new_color = vec4(match_color(COLOR, FRAGCOORD));
	if (modulation_enabled){new_color = modulate(new_color, UV);}
	new_color.a *= alpha;
	COLOR = new_color;
}
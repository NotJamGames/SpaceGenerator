shader_type canvas_item;

uniform sampler2D noise_texture;
uniform float rate;
uniform float depth;

float get_lum(vec4 color)
{
	return (color.r * 0.299) + (color.g * 0.587) + (color.b * 0.114);
}


void fragment()
{
	float offset = get_lum(texture(noise_texture, UV)) * 2.0;
	float color_mod = 0.5 * (1.0 + sin(2.0 * PI * rate * (TIME + offset)));
	COLOR *= (1.0 - (color_mod * depth));
}

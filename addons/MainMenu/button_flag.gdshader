shader_type canvas_item;

uniform float speed = 1.0;
uniform float frequency_y = 1.5;
uniform float frequency_x = 3.0;
uniform float amplitude_y = 6.5;
uniform float amplitude_x = 12.0;
uniform float inclination = 4.0;

void vertex() {
	VERTEX.y += sin((UV.x - TIME * speed) * frequency_y) * amplitude_y * UV.x;
	VERTEX.x += cos((UV.y - TIME * speed) * frequency_x) * amplitude_x * UV.x;
	VERTEX.x -= UV.y * inclination;
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	// Don't touch anything white, it's button text
	if (COLOR.rgb != vec3(1.0, 1.0, 1.0)) {
		COLOR.rgb = vec3(1.0, 1.0, 1.0);
		COLOR.rgb -= UV.y * 0.99;
}
}
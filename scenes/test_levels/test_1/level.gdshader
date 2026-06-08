shader_type spatial;
render_mode blend_mix, cull_front, unshaded; // cull_front e unshaded son la clave aquí

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 2.0; // Grosor del borde

void vertex() {
	// Convertimos las normales al espacio de la pantalla para un grosor constante
	vec4 clip_position = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
	vec3 clip_normal = mat3(PROJECTION_MATRIX) * mat3(MODELVIEW_MATRIX) * NORMAL;
	
	// Desplazamos los vértices hacia afuera en base a la normal y la resolución
	vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * outline_width;
	clip_position.xy += offset;
	
	POSITION = clip_position;
}

void fragment() {
	ALBEDO = outline_color.rgb;
}
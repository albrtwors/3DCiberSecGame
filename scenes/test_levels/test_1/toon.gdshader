shader_type spatial;
render_mode diffuse_toon, specular_toon; // ¡Corregido aquí!

uniform vec4 base_color : source_color = vec4(1.0);
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap;

uniform vec4 shadow_color : source_color = vec4(0.2, 0.2, 0.4, 1.0);
uniform float shadow_threshold : hint_range(0.0, 1.0) = 0.3;
uniform float highlight_threshold : hint_range(0.0, 1.0) = 0.7;
uniform float softness : hint_range(0.0, 0.2) = 0.02;

void fragment() {
	vec4 albedo_tex = texture(texture_albedo, UV);
	ALBEDO = base_color.rgb * albedo_tex.rgb;
}

void light() {
	float dot_product = dot(NORMAL, LIGHT);
	
	// En Godot 4, ATTENUATION maneja la atenuación de la luz y las sombras proyectadas
	float light_intensity = ATTENUATION; 
	
	float NdotL = dot_product * 0.5 + 0.5;
	
	float shadow_mask = smoothstep(shadow_threshold - softness, shadow_threshold + softness, NdotL);
	float highlight_mask = smoothstep(highlight_threshold - softness, highlight_threshold + softness, NdotL);
	
	vec3 final_shadow = mix(shadow_color.rgb * ALBEDO, ALBEDO, shadow_mask);
	vec3 final_color = mix(final_shadow, ALBEDO * 1.3, highlight_mask);
	
	DIFFUSE_LIGHT += final_color * LIGHT_COLOR * light_intensity;
}
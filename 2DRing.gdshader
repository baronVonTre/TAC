shader_type canvas_item;

uniform vec4 circle_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec2 circle_center = vec2(0.5, 0.5);
uniform float circle_radius : hint_range(0.0, 0.48) = 0.48;
uniform float circle_width: hint_range(0.0, 1.0) = 0.1;

void fragment() {
	float dist = distance(UV, circle_center);
	float inner_edge = circle_radius - circle_width;
	float outer_edge = circle_radius;
	float aa_factor = fwidth(dist);
	float alpha = smoothstep(inner_edge - aa_factor, inner_edge, dist) * (1.0 - smoothstep(outer_edge, outer_edge + aa_factor, dist));
	COLOR = vec4(circle_color.rgb, circle_color.a * alpha);
}
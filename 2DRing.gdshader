shader_type canvas_item;

uniform vec4 circle_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec2 circle_center = vec2(0.5, 0.5);
uniform float circle_radius : hint_range(0.0, 0.5) = 0.5;
uniform float circle_width: hint_range(0.0, 1.0) = 0.1;

void fragment() {
	float dist = distance(UV, circle_center);
	if(dist < circle_radius && dist > circle_radius - circle_width){
		COLOR = circle_color;
	}else{
		discard;
	}
}
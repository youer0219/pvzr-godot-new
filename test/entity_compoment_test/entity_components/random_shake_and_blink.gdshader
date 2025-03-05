// 来自：https://godotshaders.com/shader/simple-2d-random-shake-%ef%bc%86-flash/
// 有删改
shader_type canvas_item;

uniform float hit_effect : hint_range(0,1) = 0.0;
uniform float shake_intensity = 10.0;
uniform vec4 blink_color:source_color = vec4(1.0,1.0,1.0,1.0);
uniform float blink_intensity :hint_range(0.0, 1.0) = 0.0;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void vertex() {
    if (hit_effect > 0.0) {
        float time = TIME * 30.0;
        vec2 random_offset = vec2(
            rand(vec2(time, 0.0)) * 2.0 - 1.0,
            rand(vec2(time, 10.0)) * 2.0 - 1.0
        );
        VERTEX += random_offset * shake_intensity * hit_effect;
    }
}

void fragment() {
	vec4 color = texture(TEXTURE,UV);
	color = mix(color,blink_color,blink_intensity * color.a);

	COLOR = color;
}

shader_type canvas_item;
// 颜色替换参数
uniform bool use_replace_color = false;  // 新增开关
uniform vec4 replace_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); 
// 消失效果参数
uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);

    // 1. 受控的颜色替换逻辑
    if (use_replace_color && (original_color.a - 1.0) < 0.001) {
        original_color.rgb = replace_color.rgb;
    }

    // 2. 硬边缘消失逻辑（保持不变）
    float uv_y = 1.0 - UV.y;
    float alpha = step(dissolve_amount, uv_y);
    original_color.a *= alpha;

    COLOR = original_color;
}
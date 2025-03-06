shader_type canvas_item;
// 颜色替换参数
uniform vec4 replace_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // 目标颜色（默认红色）
// 消失效果参数
uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0; // 消失进度（0=全显示，1=全消失）

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);

    // 1. 颜色替换逻辑（仅处理不透明像素）
    if ((original_color.a - 1.0) < 0.001) {
        original_color.rgb = replace_color.rgb;
    }

    // 2. 硬边缘消失逻辑（无平滑过渡）
    float uv_y = 1.0 - UV.y; // 底部为0，顶部为1
    float alpha = step(dissolve_amount, uv_y); // 大于等于阈值时alpha=1.0，否则0.0
    original_color.a *= alpha;

    COLOR = original_color;
}

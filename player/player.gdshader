shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float radius = 0.45;
uniform float softness = 0.3;

void fragment() {
    vec2 center = vec2(0.5);
    float dist = distance(UV, center);

    float alpha = smoothstep(radius, radius - softness, dist);

    COLOR = vec4(glow_color.rgb, alpha * glow_color.a);
}
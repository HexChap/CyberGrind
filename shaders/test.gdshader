shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float pulse_speed = 1.0;
uniform float pulse_intensity = 0.2;

void fragment() {
    // Get the base color from the ColorRect
    vec4 color = base_color;
    // Add a pulsing effect based on time
    float pulse = sin(TIME * pulse_speed) * pulse_intensity + 1.0;
    color.rgb *= pulse;
    // Output the final color
    COLOR = color;
}
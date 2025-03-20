shader_type canvas_item;

uniform vec2 shadow_offset = vec2(5.0, 5.0);
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.5);
uniform float shadow_blur : hint_range(0.0, 10.0) = 2.0;

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    vec4 shadow = vec4(0.0);

    // Create the shadow by sampling around the offset position
    for (float x = -shadow_blur; x <= shadow_blur; x++) {
        for (float y = -shadow_blur; y <= shadow_blur; y++) {
            vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE;
            shadow += texture(TEXTURE, UV + offset + shadow_offset * TEXTURE_PIXEL_SIZE);
        }
    }
    shadow /= pow((shadow_blur * 2.0 + 1.0), 2.0);
    shadow *= shadow_color;

    // Combine the shadow and the original sprite
    COLOR = mix(shadow, original, original.a);
}

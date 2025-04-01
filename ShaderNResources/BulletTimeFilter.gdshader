shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap; // Updated for Godot 4.3
uniform vec3 tint;

void fragment() {
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    float grayscale = dot(screen_color.rgb, vec3(0.3333)); // Proper grayscale conversion
    vec3 tinted_color = mix(vec3(grayscale), tint, 0.5); // Blend with tint

    COLOR = vec4(tinted_color, screen_color.a);
}

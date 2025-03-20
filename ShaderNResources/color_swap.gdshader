//shader_type canvas_item;
//
//
//void fragment() {
	//vec4 input_color = texture(TEXTURE,UV);
	//float color_avg = (input_color.r + input_color.g + input_color.b)/3.0;
	//COLOR = vec4(color_avg,color_avg,color_avg,input_color.a);
//}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

shader_type canvas_item;

uniform vec4 custom_color : source_color = vec4(1.0);

void fragment() {
    vec4 input_color = texture(TEXTURE, UV);
    float color_avg = (input_color.r + input_color.g + input_color.b) / 3.0;
    COLOR = vec4(color_avg * custom_color.r, color_avg * custom_color.g, color_avg * custom_color.b, input_color.a);
}


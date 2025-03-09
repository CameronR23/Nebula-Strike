shader_type canvas_item;

uniform sampler2D screen_texture;  // Manual screen texture (ViewportTexture)
uniform float time_factor : hint_range(0, 1) = 0.1;
uniform float glitch_intensity : hint_range(0, 1) = 0.005;
uniform float color_shift : hint_range(0, 1) = 0.05;

void fragment() {
	
    vec2 uv = UV;  // Use UV since SCREEN_TEXTURE is gone
    vec4 screen_color = texture(screen_texture, uv);

    // Apply horizontal distortion
    float glitch_offset = sin(TIME * 10.0 * time_factor + uv.y * 50.0) * glitch_intensity;
    uv.x += glitch_offset;

    // Simulate scanlines
    float scanline = sin(uv.y * 800.0) * 0.005;
    uv.x += scanline * glitch_intensity;
    
    // Apply color channel separation
    vec4 glitch_r = texture(screen_texture, uv + vec2(color_shift, 0.0));
    vec4 glitch_g = texture(screen_texture, uv);
    vec4 glitch_b = texture(screen_texture, uv - vec2(color_shift, 0.0));

    vec4 final_color = vec4(glitch_r.r, glitch_g.g, glitch_b.b, screen_color.a);
    COLOR = final_color;
}

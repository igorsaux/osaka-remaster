// Copyright (C) 2026 Igor Spichkin
// SPDX-License-Identifier: MPL-2.0

shader_type spatial;

render_mode specular_disabled, depth_draw_opaque;

uniform vec4 albedo_color : source_color = vec4(1.0);
uniform sampler2D albedo_texture : source_color, filter_linear_mipmap;

uniform bool mirror_x = false;
uniform bool mirror_y = false;

uniform bool use_alpha_scissor = false;
uniform float alpha_scissor_threshold : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec2 custom_uv = UV;

    if (mirror_x) {
        custom_uv.x = 1.0 - custom_uv.x;
    }

    if (mirror_y) {
        custom_uv.y = 1.0 - custom_uv.y;
    }

    vec4 tex = texture(albedo_texture, custom_uv);

    ALBEDO = tex.rgb * albedo_color.rgb * COLOR.rgb;

    if (use_alpha_scissor) {
        ALPHA = tex.a * albedo_color.a;
        ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
    }
}

void light() {
    float NdotL = max(0.0, dot(NORMAL, LIGHT));

    DIFFUSE_LIGHT += ALBEDO * LIGHT_COLOR * NdotL * ATTENUATION;
}
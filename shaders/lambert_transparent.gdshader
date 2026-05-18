// Copyright (C) 2026 Igor Spichkin
// SPDX-License-Identifier: MPL-2.0

shader_type spatial;

render_mode blend_mix, specular_disabled, cull_disabled;

uniform vec4 albedo_color : source_color = vec4(1.0);
uniform sampler2D albedo_texture : source_color, filter_linear_mipmap;

void fragment() {
    vec4 tex = texture(albedo_texture, UV);
    
    ALBEDO = tex.rgb * albedo_color.rgb * COLOR.rgb;
    
    ALPHA = tex.a * albedo_color.a * COLOR.a;
}

void light() {
    float NdotL = max(0.0, dot(NORMAL, LIGHT));

    DIFFUSE_LIGHT += ALBEDO * LIGHT_COLOR * NdotL * ATTENUATION;
}
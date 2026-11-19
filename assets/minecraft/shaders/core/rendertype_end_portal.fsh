#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fog.glsl>
#include <minecraft:matrix.glsl>
#include <minecraft:globals.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;

layout(location = 0) in vec4 texProj0;
layout(location = 1) in float sphericalVertexDistance;
layout(location = 2) in float cylindricalVertexDistance;

const vec3[] COLORS = vec3[](
    vec3(0.823, 0.650, 0.964) / 12.0,
    vec3(0.823, 0.650, 0.964) / 12.0,
    vec3(0.823, 0.650, 0.964) / 12.0,
    vec3(0.823, 0.650, 0.964) / 12.0,
    vec3(0.823, 0.650, 0.964) / 12.0,
    vec3(0.823, 0.650, 0.964) / 12.0,
    vec3(0.823, 0.650, 0.964) / 12.0,
    vec3(0.823, 0.650, 0.964) / 12.0,
    vec3(0.823, 0.650, 0.964) / 12.0,
    vec3(0.823, 0.650, 0.964) / 1.0,
    vec3(0.823, 0.650, 0.964) / 1.0,
    vec3(0.823, 0.650, 0.964) / 12.0,
    vec3(0.823, 0.650, 0.964) / 12.0,
    vec3(0.823, 0.650, 0.964) / 1.0,
    vec3(0.823, 0.650, 0.964) / 12.0,
    vec3(0.823, 0.650, 0.964) / 8.0,
    vec3(0.823, 0.650, 0.964) / 8.0,
    vec3(0.823, 0.650, 0.964) / 8.0
);

const mat4 SCALE_TRANSLATE = mat4(
    0.5, 0.0, 0.0, 0.25,
    0.0, 0.5, 0.0, 0.25,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 1.0
);

mat4 end_portal_layer(float layer) {
    mat4 translate = mat4(
        1.0, 0.0, 0.0, 17.0 / layer,
        0.0, 1.0, 0.0, (2.0 + layer / 1.5) * (GameTime * 1.5),
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
    );

    mat2 rotate = mat2_rotate_z(radians((layer * layer * 4321.0 + layer * 9.0) * 2.0));

    mat2 scale = mat2((4.5 - layer / 4.0) * 2.0);

    return mat4(scale * rotate) * translate * SCALE_TRANSLATE;
}

layout(location = 0) out vec4 fragColor;

void main() {
    vec3 color = textureProj(Sampler0, texProj0).rgb * COLORS[0];
    for (int i = 0; i < PORTAL_LAYERS; i++) {
        color += textureProj(Sampler1, texProj0 * end_portal_layer(float(i + 1))).rgb * COLORS[i];
    }
    fragColor = apply_fog(vec4(color, 1.0), sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}

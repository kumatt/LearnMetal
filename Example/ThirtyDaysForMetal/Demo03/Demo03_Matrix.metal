//
//  Demo03_Matrix.metal
//  ThirtyDaysForMetal
//
//  Created by kumatt on 2025/1/2.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float3 normal;
};

vertex VertexOut vertex_main03(VertexIn in [[stage_in]],
                              constant float4x4 &modelViewMatrix [[buffer(0)]],
                              constant float3 &lightDirection [[buffer(1)]]) {
    VertexOut vertex_out;
    vertex_out.position = modelViewMatrix * in.position;
    vertex_out.color = in.color;
    vertex_out.normal = float3(0.0, 0.0, 1.0);
    return vertex_out;
}

fragment float4 fragment_main03(VertexOut in [[stage_in]]) {
    return in.color;
}
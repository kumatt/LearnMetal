//
//  Demo02_shaders.metal
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
};

vertex VertexOut vertex_main02(VertexIn in [[stage_in]]) {
    VertexOut vertex_out;
    vertex_out.position = in.position;
    vertex_out.color = in.color;
    return vertex_out;
}

fragment float4 fragment_main02(VertexOut in [[stage_in]]) {
    return in.color;
}

//
//  Demo02_Matrix.metal
//  ThirtyDaysForMetal
//
//  Created by kumatt on 2025/1/2.
//

#include <metal_stdlib>
using namespace metal;


vertex VertexOut vertex_main03(VertexIn in [[stage_in]]) {
    VertexOut vertex_out;
    vertex_out.position = in.position;
    vertex_out.color = in.color;
    return vertex_out;
}

fragment float4 fragment_main03(VertexOut in [[stage_in]]) {
    return in.color;
}
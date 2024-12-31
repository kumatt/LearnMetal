//
//  Demo01_shaders.metal
//  MetalDemo
//
//  Created by kumatt on 2024/12/31.
//

#include <metal_stdlib>
using namespace metal;

// 顶点输入结构体
struct VertexIn {
    float4 position [[attribute(0)]]; // 顶点位置
    float4 color [[attribute(1)]]; // 顶点颜色
};

// 顶点输出结构体
struct VertexOut {
    /// 返回结构体中必须有一个成员被标注为 [[position]]。这是 Metal 用来识别顶点位置的关键属性。
    float4 position [[position]]; // 顶点位置，用于光栅化
    float4 color; // 顶点颜色，用于片段着色器
};

// 顶点着色器
vertex VertexOut vertex_main(VertexIn in [[stage_in]]) {
    VertexOut out;
    // 将顶点位置传递给光栅化器
    out.position = in.position;
    // 将顶点颜色传递给片段着色器
    out.color = in.color;
    return out;
}

// 片段着色器
fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    // 返回顶点颜色
    return in.color;
}

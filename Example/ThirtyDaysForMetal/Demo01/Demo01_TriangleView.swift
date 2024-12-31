//
//  Demo01_TriangleView.swift
//  MetalDemo
//
//  Created by kumatt on 2024/12/31.
//

import SwiftUI
import MetalKit

struct Demo01_TriangleView: View {
    var body: some View {
        if let render = Demo01_TriangleRender() {
            MetalView(render: render)
        }
    }
}

#Preview {
    Demo01_TriangleView()
}

struct MetalView: UIViewRepresentable {
    
    let render: Demo01_TriangleRender
    
    // 对于iOS使用 UIViewRepresentable
    func makeCoordinator() -> Demo01_TriangleRender {
        return render
    }

    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = context.coordinator.device // 设置Metal设备
        mtkView.delegate = context.coordinator // 设置渲染委托
        mtkView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) // 设置清屏颜色
        mtkView.colorPixelFormat = .bgra8Unorm // 设置颜色附件的像素格式
        return mtkView
    }

    func updateUIView(_ uiView: MTKView, context: Context) {
        
    }
}

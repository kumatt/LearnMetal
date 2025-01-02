//
//  MetalBaseConfig.swift
//  ThirtyDaysForMetal
//
//  Created by kumatt on 2025/1/2.
//

import UIKit
import MetalKit
import SwiftUI

struct MetalDemoRepresentableView: UIViewRepresentable {
    
    let demo: any AnyMetalDemo

    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = demo.device // 设置Metal设备
        mtkView.delegate = demo.delegate // 设置渲染委托
        mtkView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) // 设置清屏颜色
        mtkView.colorPixelFormat = .bgra8Unorm // 设置颜色附件的像素格式
        return mtkView
    }

    func updateUIView(_ uiView: MTKView, context: Context) {
        
    }
}


protocol AnyMetalDemo {
    
    static func instance() -> Self?
    
    /**
     @property delegate
     @abstract The delegate handling common view operations
     */
    var delegate: (any MTKViewDelegate)? { get }

    
    /**
     @property device
     @abstract The MTLDevice used to create Metal objects
     @discussion This must be explicitly set by the application unless it was passed into the initializer. Defaults to nil
      */
    var device: (any MTLDevice)? { get }
}

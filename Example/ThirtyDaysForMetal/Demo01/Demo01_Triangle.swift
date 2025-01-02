//
//  Demo01_Triangle.swift
//  MetalDemo
//
//  Created by kumatt on 2024/12/31.
//
// MARK: - 01.创建一个最简单的三角形所需了解的概念和流程

import UIKit
import MetalKit

/// 输入的顶点数据
struct Vertex {
    var position: SIMD4<Float>
    var color: SIMD4<Float>
}

final class Demo01_TriangleRender: NSObject {
    /// GPU设备
    internal let theDevice: MTLDevice
    /// 命令队列
    private let commandQueue: MTLCommandQueue
    /// 渲染管线状态
    private let pipelineState: MTLRenderPipelineState
    /// 顶点
    private let vertices: [Vertex]
    /// 顶点缓冲
    private let vertexBuffer: MTLBuffer
    
    private init(device: MTLDevice, commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, vertices: [Vertex], vertexBuffer: MTLBuffer) {
        self.theDevice = device
        self.commandQueue = commandQueue
        self.pipelineState = pipelineState
        self.vertices = vertices
        self.vertexBuffer = vertexBuffer
        super.init()
    }
}

// MARK: - init require config
extension Demo01_TriangleRender {
    convenience init?(_ value: Void = ()) {
        /// 顶点数据
        let vertices = [
            Vertex(position: [-0.5, -0.5, 0, 1], color: [1, 0, 0, 1]),
            Vertex(position: [0.5, -0.5, 0, 1], color: [0, 1, 0, 1]),
            Vertex(position: [0, 0.5, 0, 1], color: [0, 0, 1, 1]),
        ]
        /// 获取默认的设备
        guard let device = MTLCreateSystemDefaultDevice(),
              /// 创建命令队列，用于提交渲染命令
            let commandQueue = device.makeCommandQueue(),
              /// 创建顶点缓冲区，将顶点数据传输到GPU
            let vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: []) else {
            return nil
        }
        
        // 配置渲染管线描述符
        let pipelineDescriptor = Self.createPipelineDescriptor(device: device)
        
        do {
            // 创建渲染管线状态
            let pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            self.init(device: device, commandQueue: commandQueue, pipelineState: pipelineState, vertices: vertices, vertexBuffer: vertexBuffer)
        } catch {
            print("error\(error)")
            return nil
        }
    }
}

// MARK: - create config
private extension Demo01_TriangleRender {
    /// 创建渲染管线的描述符（描述渲染管线中的各个流水线）
    class func createPipelineDescriptor(device: MTLDevice) -> MTLRenderPipelineDescriptor {
        // Step1 获取着色器方法
        /// 加载默认的着色器库
        let library = device.makeDefaultLibrary()
        /// 从默认的着色器库中获取顶点和片元着色器
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")
        
        // Step2 创建顶点描述符
        let vertexDescriptor = createVertexDescriptor()
        
        // Step3 配置渲染管线描述符
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        /// 为渲染管线描述符添加顶点着色器和片元着色器方法
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        /// 为渲染管线描述符添加顶点描述符
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        // 设置颜色附件的像素格式，需与MTKView的pixelFormat一致
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        return pipelineDescriptor
    }
    
    /// 创建顶点描述符（描述顶点数据的内容）
    class func createVertexDescriptor() -> MTLVertexDescriptor {
        // 创建顶点描述符
        let vertexDescriptor = MTLVertexDescriptor()
        // 配置位置属性
        /// 数据格式为 float4
        vertexDescriptor.attributes[0].format = .float4
        /// 在缓冲区中的偏移量
        vertexDescriptor.attributes[0].offset = 0
        /// 使用第一个缓冲区
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        /// 数据格式为 float4
        vertexDescriptor.attributes[1].format = .float4
        /// 在缓冲区中的偏移量
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD4<Float>>.stride
        /// 使用第一个缓冲区
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        // 配置缓冲区布局
        /// 每个顶点数据的步长
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        /// 每个顶点数据的步进方式
        vertexDescriptor.layouts[0].stepFunction = .perVertex
        return vertexDescriptor
    }
}

// MARK: - draw texture
extension Demo01_TriangleRender: MTKViewDelegate {
    // MTKViewDelegate 方法，当视图的drawable尺寸发生变化时调用
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // 处理视图尺寸变化，如更新投影矩阵等（本示例中不需要）
    }
    
    // MTKViewDelegate 方法，每帧调用一次，负责渲染内容
    func draw(in view: MTKView) {
        /// 获取当前可会知的drawable
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor else { return }
        
        /// 创建命令缓冲区，用于存储一系列渲染命令
        let commandBuffer = commandQueue.makeCommandBuffer()
        /// 创建渲染命令编码器，开始编码渲染命令
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        /// 设置渲染管线状态
        commandEncoder?.setRenderPipelineState(pipelineState)
        /// 设置顶点缓冲区，index 0对应Shader中的[[buffer(0)]]或[[attribute(0)]]
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        /// 绘制三角形，起始顶点为0，顶点数量为3
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        /// 结束编码
        commandEncoder?.endEncoding()
        
        /// 将渲染结果呈现在屏幕上
        commandBuffer?.present(drawable)
        /// 提交命令缓冲区，开始执行渲染命令
        commandBuffer?.commit()
    }
}

extension Demo01_TriangleRender: AnyMetalDemo {
    static func instance() -> Demo01_TriangleRender? {
        Demo01_TriangleRender()
    }
    
    var device: (any MTLDevice)? {
        theDevice
    }
    
    var delegate: (any MTKViewDelegate)? { self }
}

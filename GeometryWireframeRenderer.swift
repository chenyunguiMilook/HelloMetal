//
//  GeometryWireframeRenderer.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/5.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal
import MetalKit
import simd

public class GeometryWireframeRenderer {
    
    let name: String
    var geometry: Geometry
    var edgeBuffer: MTLBuffer!
    var shader: Shader!
    var color: UIColor!
    
    public init(name: String,
                library: MTLLibrary,
                pixelFormat: MTLPixelFormat,
                geometry: Geometry,
                color: UIColor) {
        self.name = name
        self.geometry = geometry
        self.edgeBuffer = library.device.makeBuffer(bytes: geometry.edgeBuffer, length: geometry.edgeSize, options: .storageModeShared)
        self.shader = Shader(library: library, pixelFormat: pixelFormat, vertexFuncName: "wireframe_vertex", fragmentFuncName: "wireframe_fragment")
        self.color = color
    }
    
    public func render(commandBuffer: MTLCommandBuffer, destination: MTLTexture) {
        
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].texture = destination
        descriptor.colorAttachments[0].loadAction = .load
        
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }
        commandEncoder.setRenderPipelineState(shader.renderPiplineState)
        commandEncoder.setVertexBuffer(edgeBuffer, offset: 0, index: 0)
        
        var color = float4(0.0, 0.5, 1.0, 1.0)
        commandEncoder.setFragmentBytes(&color, length: MemoryLayout<float4>.size, index: 0)
        commandEncoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: geometry.edgeCount, instanceCount: 1)
        commandEncoder.endEncoding()
    }
}









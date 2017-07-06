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
    var geometryBuffer: GeometryBuffer
    var shader: Shader!
    var color: UIColor!
    
    public init(name: String,
                library: MTLLibrary,
                pixelFormat: MTLPixelFormat,
                geometry: Geometry,
                color: UIColor) {
        self.name = name
        self.geometry = geometry
        self.geometryBuffer = GeometryBuffer(geometry: geometry, device: library.device, inflightBuffersCount: availableSources)
        self.shader = Shader(library: library, pixelFormat: pixelFormat, vertexFuncName: "wireframe_vertex", fragmentFuncName: "wireframe_fragment")
        self.color = color
    }
    
    public func render(commandEncoder: MTLRenderCommandEncoder) { // means canvas for draw
        
        let (vertexBuffer, _) = geometryBuffer.nextGeometryBuffer()
        commandEncoder.setRenderPipelineState(shader.renderPiplineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        var color = float4(0.0, 0.5, 1.0, 1.0)
        commandEncoder.setFragmentBytes(&color, length: MemoryLayout<float4>.size, index: 0)
        
        commandEncoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: 2, instanceCount: 1)
        
//        commandEncoder.drawIndexedPrimitives(type: .line,
//                                             indexCount: geometryBuffer.indexCount,
//                                             indexType: .uint32,
//                                             indexBuffer: geometryBuffer.indexBuffer,
//                                             indexBufferOffset: 0)
    }
}









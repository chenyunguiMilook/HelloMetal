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
    var geometryBuffer: GeometryWireframeBuffer!
    var shader: Shader!
    var color: Color!
    
    public init(name: String = "plane_wireframe",
                library: MTLLibrary,
                pixelFormat: MTLPixelFormat,
                geometry: Geometry,
                color: Color) {
        self.name = name
        self.geometry = geometry
        self.geometryBuffer = GeometryWireframeBuffer(geometry: geometry, device: library.device, inflightBuffersCount: availableSources)
        self.shader = Shader(library: library, pixelFormat: pixelFormat, vertexFuncName: "wireframe_vertex", fragmentFuncName: "wireframe_fragment")
        self.color = color
    }
    
    public func render(commandBuffer: MTLCommandBuffer, destination: MTLTexture) {
        
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].texture = destination
        descriptor.colorAttachments[0].loadAction = .load
        
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }
        commandEncoder.setRenderPipelineState(shader.renderPiplineState)
        commandEncoder.setVertexBuffer(geometryBuffer.nextGeometryBuffer(), offset: 0, index: 0)
        
        commandEncoder.setFragment(value: &color, for: 0)
        commandEncoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: geometry.edgeCount, instanceCount: 1)
        commandEncoder.endEncoding()
    }
}









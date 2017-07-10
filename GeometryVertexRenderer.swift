//
//  GeometryVertexRenderer.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/10.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal
import MetalKit
import simd

public class GeometryVertexRenderer {
    
    let name: String
    var geometry: Geometry
    var geometryBuffer: GeometryBuffer!
    var shader: Shader!
    var radius: Float = 0
    var color: Color!
    
    public init(name: String,
                library: MTLLibrary,
                pixelFormat: MTLPixelFormat,
                geometry: Geometry,
                radius: Float,
                color: Color) {
        self.name = name
        self.geometry = geometry
        self.geometryBuffer = GeometryBuffer(geometry: geometry, device: library.device, inflightBuffersCount: availableSources)
        self.shader = Shader(library: library, pixelFormat: pixelFormat, vertexFuncName: "point_vertex", fragmentFuncName: "point_fragment")
        self.radius = radius
        self.color = color
    }
    
    public func render(commandBuffer: MTLCommandBuffer, destination: MTLTexture) {
        
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].texture = destination
        descriptor.colorAttachments[0].loadAction = .load
        
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }
        commandEncoder.setRenderPipelineState(shader.renderPiplineState)
        
        let (vBuffer, _) = geometryBuffer.nextGeometryBuffer()
        commandEncoder.setVertexBuffer(vBuffer, offset: 0, index: 0)
        commandEncoder.setVertex(value: &radius, for: 1)
        
        commandEncoder.setFragment(value: &color, for: 0)
        commandEncoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: geometry.vertices.count, instanceCount: 1)
        commandEncoder.endEncoding()
    }
}













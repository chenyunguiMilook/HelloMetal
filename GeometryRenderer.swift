//
//  Model.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/6/29.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal
import MetalKit
import simd

public class GeometryRenderer : Filter {
    
    let name: String
    var library: MTLLibrary
    var geometry: Geometry
    var geometryBuffer: GeometryBuffer
    var textureSampler: MTLSamplerState?
    var shader: Shader!
    
    public init(name: String,
                library: MTLLibrary,
                pixelFormat: MTLPixelFormat,
                geometry: Geometry,
                textureSampler: MTLSamplerState? = nil) {
        self.name = name
        self.library = library
        self.geometry = geometry
        self.geometryBuffer = GeometryBuffer(geometry: geometry, device: library.device, inflightBuffersCount: availableSources)
        self.shader = Shader(library: library, pixelFormat: pixelFormat)
        self.textureSampler = textureSampler ?? library.device.defaultSampler
        super.init(device: library.device)
    }
    
    public func render(commandBuffer: MTLCommandBuffer, texture: MTLTexture, destination: MTLTexture) {
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = destination
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        let (vertexBuffer, uvBuffer) = geometryBuffer.nextGeometryBuffer()
        commandEncoder.setRenderPipelineState(shader.renderPiplineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBuffer(uvBuffer, offset: 0, index: 1)
        commandEncoder.setFragmentTexture(texture, index: 0)
        commandEncoder.setFragmentSamplerState(textureSampler!, index: 0)
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                            indexCount: geometryBuffer.indexCount,
                                            indexType: .uint32,
                                            indexBuffer: geometryBuffer.indexBuffer,
                                            indexBufferOffset: 0)
        commandEncoder.endEncoding()
    }
}

extension GeometryRenderer : Filterable {
    
    public func filter(texture: MTLTexture, use config: TextureConfig?, in commandBuffer: MTLCommandBuffer) -> MTLTexture {
        
        let renderTarget = self.getRenderTarget(texture: texture, config: config)
        self.render(commandBuffer: commandBuffer, texture: texture, destination: renderTarget)
        return renderTarget
    }
    
    public func filter(texture: MTLTexture, to destination: MTLTexture, in commandBuffer: MTLCommandBuffer) {
        self.render(commandBuffer: commandBuffer, texture: texture, destination: destination)
    }
}











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

public class Model {
    
    let name: String
    var geometry: GeometryBuffer
    var texture: MTLTexture?
    var textureSampler: MTLSamplerState?
    var shader: Shader!
    
    public init(name: String,
                library: MTLLibrary,
                pixelFormat: MTLPixelFormat,
                geometry: Geometry,
                texture: MTLTexture?,
                textureSampler: MTLSamplerState? = nil) {
        self.name = name
        self.geometry = GeometryBuffer(geometry: geometry, device: library.device, inflightBuffersCount: availableSources)
        self.shader = Shader(library: library, pixelFormat: pixelFormat)
        self.texture = texture
        self.textureSampler = textureSampler ?? library.device.defaultSampler
    }
    
    public func render(commandEncoder: MTLRenderCommandEncoder) { // means canvas for draw
        
        let (vertexBuffer, uvBuffer) = geometry.nextGeometryBuffer()
        commandEncoder.setRenderPipelineState(shader.renderPiplineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBuffer(uvBuffer, offset: 0, index: 1)
        
        if let texture = texture, let textureSampler = textureSampler {
            commandEncoder.setFragmentTexture(texture, index: 0)
            commandEncoder.setFragmentSamplerState(textureSampler, index: 0)
        }
        
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                            indexCount: geometry.indexCount,
                                            indexType: .uint32,
                                            indexBuffer: geometry.indexBuffer,
                                            indexBufferOffset: 0)
    }
}

public extension Model {
    
    public convenience init(name: String,
                            library: MTLLibrary,
                            pixelFormat: MTLPixelFormat,
                            geometry: Geometry,
                            texture: String,
                            textureSampler: MTLSamplerState? = nil) {
        
        let texture = loadTexture(imageNamed: texture, device: library.device)
        
        self.init(name: name,
                  library: library,
                  pixelFormat: pixelFormat,
                  geometry: geometry,
                  texture: texture,
                  textureSampler: textureSampler)
    }
    
    public convenience init(name: String,
                            library: MTLLibrary,
                            pixelFormat: MTLPixelFormat,
                            geometry: Geometry,
                            texture: UIImage,
                            textureSampler: MTLSamplerState? = nil) {
        
        let texture = loadTexture(image: texture, device: library.device)
        
        self.init(name: name,
                  library: library,
                  pixelFormat: pixelFormat,
                  geometry: geometry,
                  texture: texture,
                  textureSampler: textureSampler)
    }
}










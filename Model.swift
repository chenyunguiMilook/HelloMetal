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
    var device: MTLDevice
    var geometry: GeometryBuffer
    var texture: MTLTexture?
    
    lazy var samplerState: MTLSamplerState? = self.device.defaultSampler
    let availableSources: Int = 3
    internal var avaliableResourcesSemaphore: DispatchSemaphore
    
    deinit {
        for _ in 0 ..< availableSources {
            self.avaliableResourcesSemaphore.signal()
        }
    }
    
//    public init(name: String, device: MTLDevice, geometry: Geometry, texture: UIImage) {
//
//    }
    
    public init(name: String, device: MTLDevice, geometry: Geometry, texture: MTLTexture?) {
        
        self.name = name
        self.device = device
        self.geometry = GeometryBuffer(geometry: geometry, device: device, inflightBuffersCount: availableSources)
        self.texture = texture
        self.avaliableResourcesSemaphore = DispatchSemaphore(value: availableSources)
    }
    
    public func render(commandQueue: MTLCommandQueue,
                       pipelineState: MTLRenderPipelineState, // means shader
                       passDescriptor: MTLRenderPassDescriptor,
                       drawable: CAMetalDrawable, // means canvas for draw
                       clearColor: MTLClearColor?) {
        
        _ = self.avaliableResourcesSemaphore.wait(timeout: DispatchTime.distantFuture)
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        commandBuffer.addCompletedHandler { _ in
            self.avaliableResourcesSemaphore.signal()
        }
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor) else {
            return
        }
        let (vertexBuffer, uvBuffer) = geometry.nextGeometryBuffer()
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(uvBuffer, offset: 0, index: 1)
        
        if let texture = texture, let samplerState = samplerState {
            renderEncoder.setFragmentTexture(texture, index: 0)
            renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        }
        
        renderEncoder.drawIndexedPrimitives(type: .triangle,
                                            indexCount: geometry.indexCount,
                                            indexType: .uint32,
                                            indexBuffer: geometry.indexBuffer,
                                            indexBufferOffset: 0)
        renderEncoder.endEncoding()
        
        // the present target could be a MTLTexture
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}













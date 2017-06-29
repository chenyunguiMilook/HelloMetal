//
//  Node.swift
//  HelloMetal
//
//  Created by Andrew K. on 10/23/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import Metal
import QuartzCore
import simd

public class Node {
    
    var time: CFTimeInterval = 0.0
    
    let name: String
    var vertexCount: Int
    var vertexBuffer: MTLBuffer
    var device: MTLDevice
    
    var bufferProvider: BufferProvider<Uniforms>
    var texture: MTLTexture
    lazy var samplerState: MTLSamplerState? = self.device.defaultSampler
    
    public init(name: String, vertices: [Vertex], device: MTLDevice, texture: MTLTexture) {
        
        var vertexData = [Float]()
        for vertex in vertices {
            vertexData += vertex.floatBuffer()
        }
        
        let dataSize = vertexData.count * MemoryLayout<Float>.size
        self.vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])!
        
        self.name = name
        self.device = device
        self.vertexCount = vertices.count
        self.texture = texture
        
        self.bufferProvider = BufferProvider<Uniforms>(device: device)
    }
    
    public func render(_ commandQueue: MTLCommandQueue,
                       pipelineState: MTLRenderPipelineState,
                       drawable: CAMetalDrawable,
                       clearColor: MTLClearColor?) {
        
        _ = self.bufferProvider.avaliableResourcesSemaphore.wait(timeout: DispatchTime.distantFuture)
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0 / 255.0, blue: 5.0 / 255.0, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        commandBuffer.addCompletedHandler { (_) -> Void in
            self.bufferProvider.avaliableResourcesSemaphore.signal()
        }
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        // For now cull mode is used instead of depth buffer
        renderEncoder.setCullMode(MTLCullMode.front)
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        renderEncoder.setFragmentTexture(self.texture, index: 0)
        if let samplerState = samplerState {
            renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        }
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func updateWithDelta(_ delta: CFTimeInterval) {
        self.time += delta
    }
}







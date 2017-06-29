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
    
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    var positionZ: Float = 0.0
    
    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    var scale: Float = 1.0
    
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
                       parentModelViewMatrix: Matrix4,
                       projectionMatrix: Matrix4,
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
        
        let nodeModelMatrix = self.modelMatrix()
        nodeModelMatrix.multiplyLeft(parentModelViewMatrix)
        
        var uniform = Uniforms(modelMatrix: nodeModelMatrix.matrix, projectionMatrix: projectionMatrix.matrix)
        let uniformBuffer = bufferProvider.nextUniformsBuffer(of: &uniform)
        
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func modelMatrix() -> Matrix4 {
        let matrix: Matrix4 = Matrix4()
        matrix.translate(positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(rotationX, y: rotationY, z: rotationZ)
        matrix.scale(scale, y: scale, z: scale)
        return matrix
    }
    
    func updateWithDelta(_ delta: CFTimeInterval) {
        self.time += delta
    }
}

extension Matrix4 {
    
    public var matrix: matrix_float4x4 {
        let pointer = self.raw().assumingMemoryBound(to: matrix_float4x4.self)
        return pointer.pointee
    }
}








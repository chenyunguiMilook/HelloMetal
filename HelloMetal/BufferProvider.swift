//
//  BufferProvider.swift
//  HelloMetal
//
//  Created by Andrew  K. on 4/10/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import Metal

public class BufferProvider<T>: NSObject {
    
    fileprivate var uniformsBuffers: [MTLBuffer]
    fileprivate var avaliableBufferIndex: Int = 0
    fileprivate var bufferLength: Int
    
    internal let inflightBuffersCount: Int
    internal var avaliableResourcesSemaphore: DispatchSemaphore
    
    public init(device: MTLDevice, inflightBuffersCount: Int = 3, bufferLength: Int) {
        
        self.avaliableResourcesSemaphore = DispatchSemaphore(value: inflightBuffersCount)
        self.inflightBuffersCount = inflightBuffersCount
        self.bufferLength = bufferLength
        self.uniformsBuffers = [MTLBuffer]()
        
        for _ in 0 ..< inflightBuffersCount {
            let uniformsBuffer = device.makeBuffer(length: bufferLength, options: [])
            uniformsBuffers.append(uniformsBuffer!)
        }
    }
    
    deinit {
        for _ in 0 ..< self.inflightBuffersCount {
            self.avaliableResourcesSemaphore.signal()
        }
    }
    
    func nextUniformsBuffer(of uniform: inout T) -> MTLBuffer {
        let buffer = uniformsBuffers[avaliableBufferIndex]
        let bufferPointer = buffer.contents()
        memcpy(bufferPointer, &uniform, bufferLength)
        
        avaliableBufferIndex += 1
        if avaliableBufferIndex == inflightBuffersCount {
            avaliableBufferIndex = 0
        }
        
        return buffer
    }
}

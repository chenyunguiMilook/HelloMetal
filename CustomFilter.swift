//
//  CustomFilter.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/7.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal

public class CustomFilter : Filter {
    
    public var name: String
    public var library: MTLLibrary
    public var pipelineState: MTLComputePipelineState
    
    public init(name: String, library: MTLLibrary) {
        self.name = name
        self.library = library
        if  let function = library.makeFunction(name: name),
            let pipelineState = try? library.device.makeComputePipelineState(function: function) {
            self.pipelineState = pipelineState
        } else {
            fatalError("failed init filter ")
        }
        super.init(device: library.device)
    }
    
    public func getParameters() -> [Float] {
        return []
    }
}

extension CustomFilter : FilterProtocol {
    
    public func filter(texture: MTLTexture, use config: TextureConfig?, in commandBuffer: MTLCommandBuffer) -> MTLTexture {
        let renderTarget = self.getRenderTarget(texture: texture, config: config)
        self.filter(texture: texture, to: renderTarget, in: commandBuffer)
        return renderTarget
    }
    
    public func filter(texture: MTLTexture, to destination: MTLTexture, in commandBuffer: MTLCommandBuffer) {
        
        guard let commandEncoder = commandBuffer.makeComputeCommandEncoder() else { return }
        commandEncoder.setComputePipelineState(self.pipelineState)
        commandEncoder.setTexture(destination, index: 0)
        commandEncoder.setTexture(texture, index: 1)
        
        let parameters = self.getParameters()
        for i in 0 ..< parameters.count {
            var value = parameters[i]
            let size = MemoryLayout<Float>.size
            let buffer = library.device.makeBuffer(bytes: &value, length: size, options: [])
            commandEncoder.setBuffer(buffer, offset: 0, index: i)
        }
        let groups = MTLSizeMake(texture.width/16, texture.height/16, 1)
        let threads = MTLSizeMake(16, 16, 1)
        commandEncoder.dispatchThreadgroups(groups, threadsPerThreadgroup: threads)
        commandEncoder.endEncoding()
    }
}





























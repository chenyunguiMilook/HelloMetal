//
//  GaussianBlurFilter.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/7.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import MetalPerformanceShaders

public class MetalFilter : Filter {
    
    public var filter: MPSUnaryImageKernel
    
    public init(device: MTLDevice, filter: MPSUnaryImageKernel) {
        self.filter = filter
        super.init(device: device)
    }
}

extension MetalFilter : Filterable {
    
    public func filter(texture: MTLTexture, use config: TextureConfig?, `in` commandBuffer: MTLCommandBuffer) -> MTLTexture {
        let renderTarget = self.getRenderTarget(texture: texture, config: config)
        self.filter.encode(commandBuffer: commandBuffer, sourceTexture: texture, destinationTexture: renderTarget)
        return renderTarget
    }
    
    public func filter(texture: MTLTexture, to destination: MTLTexture, `in` commandBuffer: MTLCommandBuffer) {
        self.filter.encode(commandBuffer: commandBuffer, sourceTexture: texture, destinationTexture: destination)
    }
}



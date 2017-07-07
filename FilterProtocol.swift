//
//  Filterable.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/7.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal

public protocol FilterProtocol {
    
    // as intermediate processing, if destination config is nil, then config generate from texture
    func filter(texture: MTLTexture, use config: TextureConfig?, `in` commandBuffer: MTLCommandBuffer) -> MTLTexture
    // for present the final result
    func filter(texture: MTLTexture, to destination: MTLTexture, `in` commandBuffer: MTLCommandBuffer)
}

public struct TextureConfig {
    
    public let width: Int
    public let height: Int
    public let pixelFormat: MTLPixelFormat
}

extension TextureConfig : Equatable {
    
    public static func ==(lhs: TextureConfig, rhs: TextureConfig) -> Bool {
        return lhs.width == rhs.width &&
               lhs.height == rhs.height &&
               lhs.pixelFormat == rhs.pixelFormat
    }
}

public extension TextureConfig {
    
    public init(texture: MTLTexture) {
        self.width = texture.width
        self.height = texture.height
        self.pixelFormat = texture.pixelFormat
    }
    
    public func makeTexture(device: MTLDevice, usage: MTLTextureUsage) -> MTLTexture? {
        return createBlankTexure(device: device, pixelFormat: pixelFormat, width: width, height: height, usage: usage)
    }
}

















//
//  Filter.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/7.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal

public class Filter {
    
    var device: MTLDevice
    var texture: MTLTexture?
    var textureConfig: TextureConfig?
    
    public init(device: MTLDevice) {
        self.device = device
    }
    
    func getRenderTarget(texture: MTLTexture, config: TextureConfig?) -> MTLTexture {
        let config = config ?? TextureConfig(texture: texture)
        if self.texture == nil || textureConfig != config {
            self.texture = config.makeTexture(device: device, usage: [.shaderRead, .renderTarget])
            self.textureConfig = config
        }
        return self.texture!
    }
}

//
//  Texture.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/6/29.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import Metal

public func loadTexture(imageNamed name: String, device: MTLDevice) -> MTLTexture? {
    guard let image = UIImage.init(named: name) else { return nil }
    return loadTexture(image: image, device: device)
}

public func loadTexture(image: UIImage, device: MTLDevice) -> MTLTexture? {
    
    guard let image = image.cgImage else { return nil }
    return image.withMutableRawPointer { bytes, bytesPerRow -> MTLTexture? in
        
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = .rgba8Unorm
        descriptor.width = image.width
        descriptor.height = image.height
        
        guard let texture = device.makeTexture(descriptor: descriptor) else { return nil }
        
        let region = MTLRegionMake2D(0, 0, image.width, image.height)
        texture.replace(region: region, mipmapLevel: 0, withBytes: bytes, bytesPerRow: bytesPerRow)
        return texture
    }
}









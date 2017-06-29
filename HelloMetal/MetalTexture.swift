//
//  MetalTexture.swift
//  MetalKernelsPG
//
//  Created by Andrew K. on 10/20/14.
//  Copyright (c) 2014 Andrew K. All rights reserved.
//

import UIKit
import Metal

class MetalTexture: NSObject {
    
    var texture: MTLTexture!
    var target: MTLTextureType = .type2D
    var width: Int = 0
    var height: Int = 0
    var format: MTLPixelFormat = .rgba8Unorm
    var hasAlpha: Bool = true
    var path: String!
    let bytesPerPixel: Int = 4
    let bitsPerComponent: Int = 8
    
    init(resourceName: String, ext: String) {
        path = Bundle.main.path(forResource: resourceName, ofType: ext)
        super.init()
    }
    
    func loadTexture(device: MTLDevice, flip: Bool) {
        
        guard let image = UIImage(contentsOfFile: path)?.cgImage else { return }
        
        image.withMutableRawPointer { bytes, bytesPerRow in
            
            let texDescriptor = MTLTextureDescriptor()
                texDescriptor.pixelFormat = .rgba8Unorm
                texDescriptor.width = image.width
                texDescriptor.height = image.height
            
            self.target = texDescriptor.textureType
            self.texture = device.makeTexture(descriptor: texDescriptor)
            
            let region = MTLRegionMake2D(0, 0, image.width, image.height)
            self.texture.replace(region: region, mipmapLevel: 0, withBytes: bytes, bytesPerRow: bytesPerRow)
        }
    }
}

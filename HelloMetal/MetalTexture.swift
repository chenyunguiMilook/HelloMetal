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
    
    func loadTexture(device: MTLDevice, commandQ: MTLCommandQueue, flip: Bool) {
        
        guard let image = UIImage(contentsOfFile: path)?.cgImage else { return }
        
        self.width = image.width
        self.height = image.height
        
        let bytesPerRow = width * bytesPerPixel
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else { return }
        
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        context.clear(bounds)
        
        if flip == false {
            context.translateBy(x: 0, y: CGFloat(height))
            context.scaleBy(x: 1.0, y: -1.0)
        }
        
        context.draw(image, in: bounds)
        
        let texDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat.rgba8Unorm, width: width, height: height, mipmapped: false)
        self.target = texDescriptor.textureType
        self.texture = device.makeTexture(descriptor: texDescriptor)
        
        guard let pixelsData = context.data else { return }
        let region = MTLRegionMake2D(0, 0, Int(width), Int(height))
        self.texture.replace(region: region, mipmapLevel: 0, withBytes: pixelsData, bytesPerRow: bytesPerRow)
    }
}

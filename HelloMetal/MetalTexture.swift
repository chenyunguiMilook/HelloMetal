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
    var isMipmaped: Bool = false
    let bytesPerPixel: Int = 4
    let bitsPerComponent: Int = 8
    
    init(resourceName: String, ext: String, mipmaped: Bool) {
        path = Bundle.main.path(forResource: resourceName, ofType: ext)
        isMipmaped = mipmaped
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
        
        let texDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat.rgba8Unorm, width: width, height: height, mipmapped: isMipmaped)
        self.target = texDescriptor.textureType
        self.texture = device.makeTexture(descriptor: texDescriptor)
        
        guard let pixelsData = context.data else { return }
        let region = MTLRegionMake2D(0, 0, Int(width), Int(height))
        self.texture.replace(region: region, mipmapLevel: 0, withBytes: pixelsData, bytesPerRow: bytesPerRow)
        
        if isMipmaped == true {
            generateMipMapLayersUsingSystemFunc(texture, device: device, commandQ: commandQ, block: { (_) -> Void in
                print("mips generated")
            })
        }
        
        print("mipCount:\(texture.mipmapLevelCount)")
    }
    
    class func textureCopy(source: MTLTexture, device: MTLDevice, mipmaped: Bool) -> MTLTexture {
        let texDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat.bgra8Unorm, width: Int(source.width), height: Int(source.height), mipmapped: mipmaped)
        let copyTexture = device.makeTexture(descriptor: texDescriptor)
        
        let region = MTLRegionMake2D(0, 0, Int(source.width), Int(source.height))
        let pixelsData = malloc(source.width * source.height * 4)
        source.getBytes(pixelsData!, bytesPerRow: Int(source.width) * 4, from: region, mipmapLevel: 0)
        copyTexture?.replace(region: region, mipmapLevel: 0, withBytes: pixelsData!, bytesPerRow: Int(source.width) * 4)
        return copyTexture!
    }
    
    class func copyMipLayer(source: MTLTexture, destination: MTLTexture, mipLvl: Int) {
        let q = Int(powf(2, Float(mipLvl)))
        let mipmapedWidth = max(Int(source.width) / q, 1)
        let mipmapedHeight = max(Int(source.height) / q, 1)
        
        let region = MTLRegionMake2D(0, 0, mipmapedWidth, mipmapedHeight)
        let pixelsData = malloc(mipmapedHeight * mipmapedWidth * 4)
        source.getBytes(pixelsData!, bytesPerRow: mipmapedWidth * 4, from: region, mipmapLevel: mipLvl)
        destination.replace(region: region, mipmapLevel: mipLvl, withBytes: pixelsData!, bytesPerRow: mipmapedWidth * 4)
        free(pixelsData)
    }
    
    // MARK: - Generating UIImage from texture mip layers
    func image(mipLevel: Int) -> UIImage {
        let p = bytesForMipLevel(mipLevel: mipLevel)
        let q = Int(powf(2, Float(mipLevel)))
        let mipmapedWidth = max(width / q, 1)
        let mipmapedHeight = max(height / q, 1)
        let rowBytes = mipmapedWidth * 4
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(data: p, width: mipmapedWidth, height: mipmapedHeight, bitsPerComponent: 8, bytesPerRow: rowBytes, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        let imgRef = context?.makeImage()!
        let image = UIImage(cgImage: imgRef!)
        return image
    }
    
    func image() -> UIImage {
        return image(mipLevel: 0)
    }
    
    // MARK: - Getting raw bytes from texture mip layers
    func bytesForMipLevel(mipLevel: Int) -> UnsafeMutableRawPointer {
        let q = Int(powf(2, Float(mipLevel)))
        let mipmapedWidth = max(Int(width) / q, 1)
        let mipmapedHeight = max(Int(height) / q, 1)
        
        let rowBytes = Int(mipmapedWidth * 4)
        
        let region = MTLRegionMake2D(0, 0, mipmapedWidth, mipmapedHeight)
        let pointer = malloc(rowBytes * mipmapedHeight)
        texture.getBytes(pointer!, bytesPerRow: rowBytes, from: region, mipmapLevel: mipLevel)
        return pointer!
    }
    
    func bytes() -> UnsafeMutableRawPointer {
        return bytesForMipLevel(mipLevel: 0)
    }
    
    func generateMipMapLayersUsingSystemFunc(_ texture: MTLTexture, device: MTLDevice, commandQ: MTLCommandQueue, block: @escaping MTLCommandBufferHandler) {
        
        guard let commandBuffer = commandQ.makeCommandBuffer() else { return }
        guard let blitCommandEncoder = commandBuffer.makeBlitCommandEncoder() else { return }
        
        blitCommandEncoder.generateMipmaps(for: texture)
        blitCommandEncoder.endEncoding()
        
        commandBuffer.addCompletedHandler(block)
        commandBuffer.commit()
    }
}

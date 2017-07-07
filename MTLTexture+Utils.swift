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
    
    guard let image = UIImage(named: name) else { return nil }
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

public func createBlankTexure(device: MTLDevice, pixelFormat: MTLPixelFormat, width: Int, height: Int, usage: MTLTextureUsage) -> MTLTexture?
{
    let descriptor = MTLTextureDescriptor()
    descriptor.width = width
    descriptor.height = height
    descriptor.pixelFormat = pixelFormat
    descriptor.usage = usage
    descriptor.mipmapLevelCount = 1
    return device.makeTexture(descriptor: descriptor)
}

public func createBlankTexture(device: MTLDevice, texture: MTLTexture, usage: MTLTextureUsage) -> MTLTexture?
{
    let descriptor = MTLTextureDescriptor()
    descriptor.width = texture.width
    descriptor.height = texture.height
    descriptor.pixelFormat = texture.pixelFormat
    descriptor.usage = usage
    descriptor.mipmapLevelCount = 1
    return device.makeTexture(descriptor: descriptor)
}

public func createMutableTexture(device: MTLDevice, commandQueue: MTLCommandQueue, texture: MTLTexture, usage: MTLTextureUsage) -> MTLTexture?
{
    guard let baseTexture = createBlankTexture(device: device, texture: texture, usage: usage) else { return nil }
    guard let commandBuffer = commandQueue.makeCommandBuffer() else { return nil }
    guard let blitEncoder = commandBuffer.makeBlitCommandEncoder() else { return nil }
    
    let originZero = MTLOriginMake(0, 0, 0)
    let size = MTLSizeMake(texture.width, texture.height, 1)
    
    blitEncoder.copy(
        from: texture,
        sourceSlice: 0,
        sourceLevel: 0,
        sourceOrigin: originZero,
        sourceSize: size,
        to: baseTexture,
        destinationSlice: 0,
        destinationLevel: 0,
        destinationOrigin: originZero
    )
    blitEncoder.endEncoding()
    
    commandBuffer.commit()
    commandBuffer.waitUntilCompleted()
    
    return baseTexture
}

extension MTLTexture
{
    func exportImage() -> UIImage?
    {
        let bytesCount = width * height * 4
        let bytesPerRow = width * 4
        
        guard let bytes: UnsafeMutableRawPointer = malloc(bytesCount) else { return nil }
        let region = MTLRegionMake2D(0, 0, width, height)
        getBytes(bytes, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
        
        guard let dataProvider = CGDataProvider(dataInfo: nil, data: bytes, size: bytesCount, releaseData: { _, _, _ in }) else { return nil }
        
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitMapInfo = CGBitmapInfo([
            CGBitmapInfo.byteOrder32Little,
            CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)
        ])
        
        let cgImage = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitMapInfo,
            provider: dataProvider,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent)
        
        if let cgImage = cgImage {
            return UIImage( cgImage: cgImage, scale: 0.0, orientation: .up )
        } else {
            return nil
        }
    }
}

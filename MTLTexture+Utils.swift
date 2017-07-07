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

public func createBlankTexure(device: MTLDevice, pixelFormat:MTLPixelFormat, width:Int, height:Int) -> MTLTexture?
{
    let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
        pixelFormat:pixelFormat,
        width:width,
        height:height,
        mipmapped:false)
    
    return device.makeTexture( descriptor:textureDescriptor)
}

public func createMutableTexture(device: MTLDevice, commandQueue: MTLCommandQueue, texture:MTLTexture) -> MTLTexture?
{
    let width:Int = texture.width
    let height:Int = texture.height
    guard let baseTexture:MTLTexture = createBlankTexure(
        device: device,
        pixelFormat:texture.pixelFormat,
        width:width,
        height:height) else { return nil }
    
    guard let textureBuffer = commandQueue.makeCommandBuffer() else { return nil }
    guard let blitEncoder = textureBuffer.makeBlitCommandEncoder() else { return nil }
    
    let originZero = MTLOriginMake(0, 0, 0)
    let size = MTLSizeMake(width, height,1)
    
    blitEncoder.copy(
        from:texture,
        sourceSlice:0,
        sourceLevel:0,
        sourceOrigin:originZero,
        sourceSize:size,
        to:baseTexture,
        destinationSlice:0,
        destinationLevel:0,
        destinationOrigin:originZero)
    blitEncoder.endEncoding()
    
    textureBuffer.commit()
    textureBuffer.waitUntilCompleted()
    
    return baseTexture
}

extension MTLTexture
{
    func exportImage() -> UIImage?
    {
        let image:UIImage?
        let byteCount:Int = width * height * 4
        
        guard
            
            let bytes:UnsafeMutableRawPointer = malloc(byteCount)
            
            else
        {
            return nil
        }
        
        let bytesPerRow:Int = width * 4
        let region:MTLRegion = MTLRegionMake2D(0, 0, width, height)
        getBytes(bytes, bytesPerRow:bytesPerRow, from:region, mipmapLevel:0)
        
        guard
            
            let dataProvider:CGDataProvider = CGDataProvider(
                dataInfo:nil,
                data:bytes,
                size:byteCount,
                releaseData:
                { (info, data, size) in
            })
            
            else
        {
            return nil
        }
        
        let bitsPerComponent:Int = 8
        let bitsPerPixel:Int = 32
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitMapInfo:CGBitmapInfo = CGBitmapInfo([
            CGBitmapInfo.byteOrder32Little,
            CGBitmapInfo(rawValue:CGImageAlphaInfo.noneSkipFirst.rawValue)
            ])
        let renderingIntent:CGColorRenderingIntent = CGColorRenderingIntent.defaultIntent
        
        guard
            
            let cgImage:CGImage = CGImage(
                width:width,
                height:height,
                bitsPerComponent:bitsPerComponent,
                bitsPerPixel:bitsPerPixel,
                bytesPerRow:bytesPerRow,
                space:colorSpace,
                bitmapInfo:bitMapInfo,
                provider:dataProvider,
                decode:nil,
                shouldInterpolate:false,
                intent:renderingIntent)
            
            else
        {
            return nil
        }
        
        image = UIImage(
            cgImage:cgImage,
            scale:0.0,
            orientation:UIImageOrientation.up)
        
        return image
    }
}








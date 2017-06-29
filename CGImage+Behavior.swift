//
//  CGImage+Behavior.swift
//  MetalTexture
//
//  Created by chenyungui on 2017/6/29.
//  Copyright © 2017年 chenyungui. All rights reserved.
//

import Foundation
import CoreGraphics
import MetalKit

extension CGImage {
    
    public func withMutableRawPointer<Result>(_ body: (UnsafeMutableRawPointer) throws -> Result) rethrows -> Result {
        
        var imageData: UnsafeMutableRawPointer!
        var dataFromProvider:CFData!
        
        let width = self.width
        let height = self.height
        let size = CGSize(width: CGFloat(width), height: CGFloat(height))
        let length = width * height * 4
        var format = MTLPixelFormat.bgra8Unorm
        let needRedraw = !self.isCompatibleWithMetal
        
        if needRedraw {
            imageData = UnsafeMutableRawPointer.allocate(bytes: length, alignedTo: 4)
            
            let bytesPerRow = width * 4
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let alphaInfo = CGImageAlphaInfo.premultipliedLast.rawValue
            let imageBounds = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
            let imageContext = CGContext(data: imageData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: alphaInfo)
            imageContext?.draw(self, in: imageBounds)
        }
        else {
            dataFromProvider = self.dataProvider?.data
            let pointer = CFDataGetBytePtr(dataFromProvider)
            imageData = UnsafeMutableRawPointer(mutating: pointer)
            format = .rgba8Unorm /* important here */
        }
        
        defer {
            if needRedraw {
                imageData.deallocate(bytes: length, alignedTo: 4)
            }
        }
        
        return try body(imageData)
    }
    
    public var isCompatibleWithMetal:Bool {
        
        let w = self.width
        let bytesPerRow = self.bytesPerRow
        let bitsPerPixel = self.bitsPerPixel
        let bitsPerComponent = self.bitsPerComponent
        
        guard bytesPerRow == w * 4 && bitsPerPixel == 32 && bitsPerComponent == 8 else { return false }
        
        /* Check that the bitmap pixel format is compatible with GL */
        let bitmapInfo = self.bitmapInfo
        if (bitmapInfo.contains(.floatComponents)) {
            /* We don't support float components for use directly in GL */
            return false
        }
        else {
            let alphaInfo = CGImageAlphaInfo(rawValue:bitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue)
            if (bitmapInfo.contains(.byteOrder32Little)) {
                /* Little endian, for alpha-first we can use this bitmap directly in GL */
                if ((alphaInfo != CGImageAlphaInfo.premultipliedFirst) && (alphaInfo != CGImageAlphaInfo.first) && (alphaInfo != CGImageAlphaInfo.noneSkipFirst)) {
                    return false
                }
            } else if ((bitmapInfo.contains(CGBitmapInfo())) || (bitmapInfo.contains(.byteOrder32Big))) {
                /* Big endian, for alpha-last we can use this bitmap directly in GL */
                if ((alphaInfo != CGImageAlphaInfo.premultipliedLast) && (alphaInfo != CGImageAlphaInfo.last) && (alphaInfo != CGImageAlphaInfo.noneSkipLast)) {
                    return false
                }
            }
        }
        return true
    }
}

//
//  Renderer.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/6/29.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal
import MetalKit
import MetalPerformanceShaders

let availableSources: Int = 3

public protocol RendererDelegate : class {
    func renderer(_ renderer: Renderer, didFinishRenderingWith image: UIImage?)
}

public class Renderer : NSObject {
    
    public weak var delegate: RendererDelegate?
    
    var device: MTLDevice!
    var library: MTLLibrary!
    var commandQueue: MTLCommandQueue!
    var model: Plane!
    var texture: MTLTexture!
    var filter: GaussianBlurFilter!
    
    var avaliableResourcesSemaphore: DispatchSemaphore!
    
    deinit {
        for _ in 0 ..< availableSources {
            self.avaliableResourcesSemaphore.signal()
        }
    }
    
    public init(device: MTLDevice) {
        super.init()
        self.device = device
        self.library = device.makeDefaultLibrary()!
        self.commandQueue = device.makeCommandQueue()
        self.model = Plane(library: library, pixelFormat: .bgra8Unorm)
        self.model.geometry.uvTransform = getUVTransformForFlippedVertically()
        self.texture = loadTexture(imageNamed: "cube.png", device: device)
        self.filter = GaussianBlurFilter(device: device, sigma: 5.0)
        self.avaliableResourcesSemaphore = DispatchSemaphore(value: availableSources)
    }
    
    public func render(in drawable: CAMetalDrawable) {
        
        _ = self.avaliableResourcesSemaphore.wait(timeout: DispatchTime.distantFuture)
        
        // MARK: - start render model to a texture
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        commandBuffer.addCompletedHandler { _ in
            // copy pixel buffer from drawable.texture
            //self.delegate?.renderer(self, didFinishRenderingWith: drawable.texture.exportImage())
            self.avaliableResourcesSemaphore.signal()
        }
        
        let config = TextureConfig.init(texture: drawable.texture)
        let filterResult = self.model.filter(texture: texture, use: config, in: commandBuffer)
        
        // MARK: - filter the texture and present it
        self.filter.filter(texture: filterResult, to: drawable.texture, in: commandBuffer)
        
        commandBuffer.present(drawable) // the present target could be a MTLTexture
        commandBuffer.commit()
    }
}











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

let availableSources: Int = 3

public class Renderer : NSObject {

    var device: MTLDevice!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var model: Plane!
    
    var avaliableResourcesSemaphore: DispatchSemaphore!
    
    deinit {
        for _ in 0 ..< availableSources {
            self.avaliableResourcesSemaphore.signal()
        }
    }
    
    public init(device: MTLDevice) {
        super.init()
        self.device = device
        self.commandQueue = device.makeCommandQueue()
        self.model = Plane(library: device.makeDefaultLibrary()!, pixelFormat: .bgra8Unorm, texture: "cube.png")
        self.avaliableResourcesSemaphore = DispatchSemaphore(value: availableSources)
    }
    
    public func render(in drawable: CAMetalDrawable) {
        
        _ = self.avaliableResourcesSemaphore.wait(timeout: DispatchTime.distantFuture)
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        commandBuffer.addCompletedHandler { _ in
            self.avaliableResourcesSemaphore.signal()
        }
        
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        
        self.model.render(commandEncoder: commandEncoder)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable) // the present target could be a MTLTexture
        commandBuffer.commit()
    }
}











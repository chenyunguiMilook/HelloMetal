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

public class Renderer : NSObject {

    var device: MTLDevice!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var model: ModelPlane!
    
    public init(device: MTLDevice) {
        super.init()
        self.device = device
        self.commandQueue = device.makeCommandQueue()
        self.model = ModelPlane(library: device.makeDefaultLibrary()!, pixelFormat: .bgra8Unorm, texture: "cube.png")
    }
    
    public func render(in drawable: CAMetalDrawable) {
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        self.model.render(commandQueue: commandQueue,
                          passDescriptor: renderPassDescriptor,
                          drawable: drawable)
    }
}











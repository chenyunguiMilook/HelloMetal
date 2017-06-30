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
        
        let texture = MetalTexture(resourceName: "cube", ext: "png")
            texture.loadTexture(device: device, flip: true)
        self.model = ModelPlane(device: device, texture: texture.texture)
        
        self.compileShader()
    }
    
    internal func compileShader() {
        
        let defaultLibrary = device.makeDefaultLibrary()
        let fragmentProgram = defaultLibrary!.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary!.makeFunction(name: "basic_vertex")
        
        let piplineDescriptor = MTLRenderPipelineDescriptor()
        piplineDescriptor.vertexFunction = vertexProgram
        piplineDescriptor.fragmentFunction = fragmentProgram
        piplineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: piplineDescriptor)
        } catch let error as NSError {
            print("Failed to create pipeline state, error \(error.localizedDescription)")
        }
    }
    
    public func render(in drawable: CAMetalDrawable) {
        
        self.model.render(commandQueue,
                          pipelineState: pipelineState,
                          drawable: drawable,
                          clearColor: nil)
    }
}











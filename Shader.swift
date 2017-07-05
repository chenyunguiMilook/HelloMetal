//
//  Shader.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/5.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal

public class Shader {
    
    public var renderPiplineState: MTLRenderPipelineState!
    
    public init(device: MTLDevice) {
        
        let defaultLibrary = device.makeDefaultLibrary()
        let fragmentProgram = defaultLibrary!.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary!.makeFunction(name: "basic_vertex")
        
        let descriptor = MTLRenderPipelineDescriptor()
            descriptor.vertexFunction = vertexProgram
            descriptor.fragmentFunction = fragmentProgram
            descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            renderPiplineState = try device.makeRenderPipelineState(descriptor: descriptor)
        } catch let error as NSError {
            print("Failed to create pipeline state, error \(error.localizedDescription)")
        }
    }
}

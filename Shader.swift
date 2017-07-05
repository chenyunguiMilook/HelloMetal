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
    
    public init(device: MTLDevice, library: MTLLibrary? = nil, vertexFuncName: String = "basic_vertex", fragmentFuncName: String = "basic_fragment") {
        
        let library = library ?? device.makeDefaultLibrary()!
        let vertexProgram = library.makeFunction(name: vertexFuncName)
        let fragmentProgram = library.makeFunction(name: fragmentFuncName)
        
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
